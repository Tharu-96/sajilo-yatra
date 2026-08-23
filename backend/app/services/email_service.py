"""Robust email sending via Brevo (Sendinblue) HTTP API.

Falls back to direct SMTP only if BREVO_API_KEY is not configured.
Brevo sends over HTTPS (port 443) which works on all cloud platforms
including Render's free tier where SMTP ports 465/587 are blocked.
"""

import json
import logging
import smtplib
import urllib.request
from email.message import EmailMessage

from ..config import settings

logger = logging.getLogger(__name__)


def _send_via_brevo(message: EmailMessage) -> None:
    """Send an email using Brevo's transactional email HTTP API."""
    from email.utils import parseaddr
    
    api_key = settings.brevo_api_key.strip()
    if not api_key:
        raise RuntimeError("BREVO_API_KEY is not configured.")

    sender_name, sender_email = parseaddr(message["From"])
    if not sender_email:
        sender_email = settings.smtp_username
        
    to_name, to_email = parseaddr(message["To"])
    if not to_email:
        to_email = message["To"]

    subject = message["Subject"] or "(no subject)"
    body = message.get_content()

    payload_dict = {
        "sender": {"email": sender_email, "name": sender_name or "Sajilo Yatra"},
        "to": [{"email": to_email, "name": to_name} if to_name else {"email": to_email}],
        "subject": subject,
        "textContent": body,
    }
    
    # Brevo API allows Reply-To headers
    reply_to_name, reply_to_email = parseaddr(message.get("Reply-To", ""))
    if reply_to_email:
        payload_dict["replyTo"] = {"email": reply_to_email, "name": reply_to_name}
        
    payload = json.dumps(payload_dict).encode("utf-8")

    req = urllib.request.Request(
        "https://api.brevo.com/v3/smtp/email",
        data=payload,
        headers={
            "api-key": api_key,
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            resp_body = resp.read().decode("utf-8")
            logger.info(f"Brevo email sent successfully: {resp.status} {resp_body}")
    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8")
        logger.error(f"Brevo API error {e.code}: {error_body}")
        raise RuntimeError(f"Brevo API error {e.code}: {error_body}") from e


def _send_via_smtp(message: EmailMessage) -> None:
    """Send email via direct SMTP (works locally, blocked on some cloud hosts)."""
    host = settings.smtp_host.strip()
    port = int(settings.smtp_port)
    username = settings.smtp_username.strip()
    password = settings.smtp_password.strip().strip('"\'')

    ports_to_try = [port]
    if port == 587 and 465 not in ports_to_try:
        ports_to_try.append(465)
    elif port == 465 and 587 not in ports_to_try:
        ports_to_try.append(587)

    last_error = None
    for p in ports_to_try:
        try:
            logger.info(f"Attempting SMTP via {host}:{p}...")
            if p == 465:
                with smtplib.SMTP_SSL(host, p, timeout=15) as smtp:
                    smtp.login(username, password)
                    smtp.send_message(message)
            else:
                with smtplib.SMTP(host, p, timeout=15) as smtp:
                    smtp.starttls()
                    smtp.login(username, password)
                    smtp.send_message(message)
            logger.info(f"Email sent successfully via SMTP {host}:{p}")
            return
        except Exception as err:
            logger.error(f"SMTP failed via {host}:{p}: {err}")
            last_error = err

    if last_error:
        raise last_error


def send_email_message(message: EmailMessage) -> None:
    """Send an email, preferring Brevo HTTP API, falling back to SMTP."""
    # Prefer Brevo (works on all cloud platforms over HTTPS)
    if settings.brevo_api_key:
        logger.info("Sending email via Brevo HTTP API...")
        _send_via_brevo(message)
        return

    # Fallback to direct SMTP (works locally, may be blocked on cloud)
    logger.info("BREVO_API_KEY not set, falling back to SMTP...")
    _send_via_smtp(message)
