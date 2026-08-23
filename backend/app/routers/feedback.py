import smtplib
from email.message import EmailMessage
from email.utils import formataddr

from fastapi import APIRouter, Depends, HTTPException, status

from ..config import settings
from ..models import User
from ..schemas import FeedbackRequest
from ..security import get_current_user

router = APIRouter()


@router.post("", status_code=status.HTTP_202_ACCEPTED)
def send_feedback(
    feedback: FeedbackRequest,
    current_user: User = Depends(get_current_user),
) -> dict[str, str]:
    """Deliver customer feedback using the server's configured SMTP account."""
    has_smtp = all([
        settings.smtp_host,
        settings.smtp_username,
        settings.smtp_password,
        settings.support_email,
    ])
    has_brevo = all([
        settings.brevo_api_key,
        settings.smtp_username,
        settings.support_email,
    ])

    if not (has_smtp or has_brevo):
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Feedback email is not configured.",
        )

    email = EmailMessage()
    # Gmail requires messages sent through this SMTP account to use that account
    # as the actual sender.  A descriptive display name plus Reply-To preserves
    # the user's identity and lets support reply directly to them.
    email["From"] = formataddr(
        (f"Sajilo Yatra Feedback from {current_user.name}", settings.smtp_username)
    )
    email["To"] = settings.support_email
    email["Reply-To"] = formataddr((current_user.name, current_user.email))
    email["Subject"] = (
        f"[Sajilo Yatra Feedback] {feedback.subject.strip()} "
        f"— {current_user.name} <{current_user.email}>"
    )
    email.set_content(
        f"Feedback from: {current_user.name}\n"
        f"Email: {current_user.email}\n\n"
        f"{feedback.message.strip()}"
    )

    try:
        from ..services.email_service import send_email_message
        send_email_message(email)
    except Exception as error:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Unable to send feedback right now. Please try again later.",
        ) from error

    return {"message": "Feedback accepted for delivery."}
