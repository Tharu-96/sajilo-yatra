import smtplib
import logging
from email.message import EmailMessage
from ..config import settings

logger = logging.getLogger(__name__)

def send_email_message(message: EmailMessage) -> None:
    host = settings.smtp_host.strip()
    port = int(settings.smtp_port)
    username = settings.smtp_username.strip()
    # Strip any accidental surrounding quotes or trailing whitespace
    password = settings.smtp_password.strip().strip('"\'')

    # Try port 465 SSL first if configured, or fallback between 587 and 465
    ports_to_try = [port]
    if port == 587 and 465 not in ports_to_try:
        ports_to_try.append(465)
    elif port == 465 and 587 not in ports_to_try:
        ports_to_try.append(587)

    last_error = None
    for p in ports_to_try:
        try:
            logger.info(f"Attempting to send email via {host}:{p}...")
            if p == 465:
                with smtplib.SMTP_SSL(host, p, timeout=15) as smtp:
                    smtp.login(username, password)
                    smtp.send_message(message)
            else:
                with smtplib.SMTP(host, p, timeout=15) as smtp:
                    smtp.starttls()
                    smtp.login(username, password)
                    smtp.send_message(message)
            logger.info(f"Email sent successfully via {host}:{p}!")
            return
        except Exception as err:
            logger.error(f"Failed sending email via {host}:{p}: {err}")
            last_error = err

    if last_error:
        raise last_error
