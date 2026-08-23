from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    database_url: str = "sqlite:///./sajilo_yatra.db"
    allowed_origins: str = "http://localhost:3000,http://localhost:8080"
    smtp_host: str = ""
    smtp_port: int = 587
    smtp_username: str = ""
    smtp_password: str = ""
    support_email: str = ""
    brevo_api_key: str = ""

    # Authentication. jwt_secret_key MUST be overridden in production via env.
    jwt_secret_key: str = "CHANGE_ME_IN_PRODUCTION_use_a_long_random_secret"
    jwt_algorithm: str = "HS256"
    jwt_expire_hours: int = 24
    otp_expire_minutes: int = 10
    profile_image_storage_dir: str = "uploads/profile-images"

    port: int = 8000
    
    @property
    def cors_origins(self) -> List[str]:
        # Always allow all origins in development/demo, but can be restricted via ALLOWED_ORIGINS
        if not self.allowed_origins:
            return ["*"]
        return [origin.strip() for origin in self.allowed_origins.split(",")]

    class Config:
        env_file = ".env"
        # Mobile and deployment .env files can contain keys used by other
        # services. They must not stop the API from starting.
        extra = "ignore"


settings = Settings()
