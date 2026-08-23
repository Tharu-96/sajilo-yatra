"""Authentication endpoints: register, login, forgot/reset password, current user."""
import secrets
import smtplib
import uuid
from datetime import datetime, timedelta, timezone
from email.message import EmailMessage
from pathlib import Path

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile, status
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session

from ..config import settings
from ..database import get_db
from ..models import User
from ..schemas import (
    ForgotPasswordRequest,
    ResetPasswordRequest,
    Token,
    UserCreate,
    UserLogin,
    UserOut,
)
from ..security import (
    create_access_token,
    get_current_user,
    hash_password,
    verify_password,
)

router = APIRouter()

# Reused for both wrong-email and wrong-password so we never reveal which failed.
_INVALID_CREDENTIALS = "Invalid email or password."
_PROFILE_IMAGE_MAX_BYTES = 5 * 1024 * 1024
_PROFILE_IMAGE_MEDIA_TYPES = {"image/jpeg", "image/png", "image/webp"}
_PROFILE_IMAGE_EXTENSIONS = {
    "image/jpeg": ".jpg",
    "image/png": ".png",
    "image/webp": ".webp",
}


def _profile_image_directory() -> Path:
    directory = Path(settings.profile_image_storage_dir).resolve()
    directory.mkdir(parents=True, exist_ok=True)
    return directory


def _profile_image_path(filename: str | None) -> Path | None:
    if not filename:
        return None
    directory = _profile_image_directory()
    path = (directory / filename).resolve()
    try:
        path.relative_to(directory)
    except ValueError:
        return None
    return path


def _to_user_out(user: User) -> UserOut:
    return UserOut(id=user.id, name=user.name, email=user.email)






def _issue_token(user: User) -> Token:
    access_token = create_access_token(subject=user.id)
    return Token(access_token=access_token, user=_to_user_out(user))


@router.post("/register", response_model=Token, status_code=status.HTTP_201_CREATED)
def register(payload: UserCreate, db: Session = Depends(get_db)) -> Token:
    email = payload.email.lower().strip()
    existing = db.query(User).filter(User.email == email).first()
    if existing is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="An account with this email already exists.",
        )

    user = User(
        id=str(uuid.uuid4()),
        name=payload.name.strip(),
        email=email,
        hashed_password=hash_password(payload.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return _issue_token(user)


@router.post("/login", response_model=Token)
def login(payload: UserLogin, db: Session = Depends(get_db)) -> Token:
    email = payload.email.lower().strip()
    user = db.query(User).filter(User.email == email).first()
    if user is None or not verify_password(payload.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=_INVALID_CREDENTIALS,
        )
    return _issue_token(user)


@router.post("/forgot-password", status_code=status.HTTP_202_ACCEPTED)
def forgot_password(
    payload: ForgotPasswordRequest, db: Session = Depends(get_db)
) -> dict[str, str]:
    # Always return the same generic response to avoid leaking which emails exist.
    generic_response = {
        "message": "If an account exists for this email, a reset code has been sent."
    }

    email = payload.email.lower().strip()
    user = db.query(User).filter(User.email == email).first()
    if user is None:
        return generic_response

    if not all([settings.smtp_host, settings.smtp_username, settings.smtp_password]):
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Password reset email is not configured.",
        )

    otp = f"{secrets.randbelow(1_000_000):06d}"
    user.reset_otp_hash = hash_password(otp)
    user.reset_otp_expires_at = datetime.now(timezone.utc) + timedelta(
        minutes=settings.otp_expire_minutes
    )
    db.commit()

    message = EmailMessage()
    message["From"] = settings.smtp_username
    message["To"] = user.email
    message["Subject"] = "Sajilo Yatra Password Reset Code"
    message.set_content(
        f"Your Sajilo Yatra password reset code is: {otp}\n\n"
        f"This code expires in {settings.otp_expire_minutes} minutes. "
        "If you did not request this, you can safely ignore this email."
    )

    try:
        from ..services.email_service import send_email_message
        send_email_message(message)
    except Exception as error:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Unable to send reset code right now. Please try again later.",
        ) from error

    return generic_response


@router.post("/reset-password", status_code=status.HTTP_200_OK)
def reset_password(
    payload: ResetPasswordRequest, db: Session = Depends(get_db)
) -> dict[str, str]:
    invalid_otp = HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail="Invalid or expired reset code.",
    )

    email = payload.email.lower().strip()
    user = db.query(User).filter(User.email == email).first()
    if user is None or not user.reset_otp_hash or user.reset_otp_expires_at is None:
        raise invalid_otp

    expires_at = user.reset_otp_expires_at
    if expires_at.tzinfo is None:
        expires_at = expires_at.replace(tzinfo=timezone.utc)
    if expires_at < datetime.now(timezone.utc):
        raise invalid_otp

    if not verify_password(payload.otp, user.reset_otp_hash):
        raise invalid_otp

    user.hashed_password = hash_password(payload.new_password)
    user.reset_otp_hash = None
    user.reset_otp_expires_at = None
    db.commit()

    return {"message": "Password updated successfully."}


@router.get("/me", response_model=UserOut)
def read_current_user(current_user: User = Depends(get_current_user)) -> UserOut:
    return _to_user_out(current_user)


@router.put("/me/profile-image")
async def upload_profile_image(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict[str, str]:
    """Replace the authenticated user's profile image."""
    if file.content_type not in _PROFILE_IMAGE_MEDIA_TYPES:
        raise HTTPException(
            status_code=status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
            detail="Profile image must be a JPEG, PNG, or WebP file.",
        )

    image_bytes = await file.read()
    if not image_bytes or len(image_bytes) > _PROFILE_IMAGE_MAX_BYTES:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail="Profile image must be no larger than 5 MB.",
        )

    filename = f"{current_user.id}-{uuid.uuid4().hex}{_PROFILE_IMAGE_EXTENSIONS[file.content_type]}"
    image_path = _profile_image_directory() / filename
    image_path.write_bytes(image_bytes)

    previous_path = _profile_image_path(current_user.profile_image_filename)
    current_user.profile_image_filename = filename
    db.commit()

    if previous_path is not None:
        previous_path.unlink(missing_ok=True)

    return {"message": "Profile image saved."}


@router.get("/me/profile-image")
def get_profile_image(
    current_user: User = Depends(get_current_user),
) -> FileResponse:
    """Return only the authenticated user's saved profile image."""
    image_path = _profile_image_path(current_user.profile_image_filename)
    if image_path is None or not image_path.is_file():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Profile image not found.")
    return FileResponse(image_path)


@router.delete("/me/profile-image", status_code=status.HTTP_204_NO_CONTENT)
def delete_profile_image(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> None:
    """Remove the authenticated user's profile image."""
    image_path = _profile_image_path(current_user.profile_image_filename)
    current_user.profile_image_filename = None
    db.commit()
    if image_path is not None:
        image_path.unlink(missing_ok=True)
