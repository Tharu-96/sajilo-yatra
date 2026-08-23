from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from .config import settings
db_url = settings.database_url
if db_url.startswith("postgres://"):
    db_url = db_url.replace("postgres://", "postgresql://", 1)

# Neon pooler (-pooler) uses PgBouncer in transaction mode which can drop session schema/search_path.
# Removing -pooler connects directly to the instance, which is recommended for SQLAlchemy.
if "-pooler." in db_url:
    db_url = db_url.replace("-pooler.", ".")

engine = create_engine(db_url)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
