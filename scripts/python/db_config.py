"""PostgreSQL connection settings from .env (optional) or OS environment variables."""
import os
from pathlib import Path

try:
    from dotenv import load_dotenv as _dotenv_load
except ImportError:
    _dotenv_load = None


def _load_env_file_builtin(env_path: Path, override: bool = False) -> None:
    """Parse a simple .env file without python-dotenv."""
    for line in env_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" not in line:
            continue
        key, _, value = line.partition("=")
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if not key:
            continue
        if override or key not in os.environ:
            os.environ[key] = value


def load_project_env(project_root: Path, override: bool = False) -> bool:
    """Load repo-root .env into os.environ. Returns True if file was loaded."""
    env_file = project_root / ".env"
    if not env_file.is_file():
        return False

    if _dotenv_load is not None:
        return bool(_dotenv_load(env_file, override=override))

    _load_env_file_builtin(env_file, override=override)
    return True


def get_db_settings(project_root: Path | None = None) -> dict[str, str]:
    """
    Load credentials in this order:
    1. Existing OS / user / shell environment variables
    2. Repo-root .env file (python-dotenv if installed, else built-in parser)
    """
    if project_root is not None:
        load_project_env(project_root, override=False)

    settings = {
        "username": os.getenv("POSTGRES_USER") or os.getenv("PGUSER", "postgres"),
        "password": os.getenv("POSTGRES_PASSWORD") or os.getenv("PGPASSWORD", ""),
        "host": os.getenv("POSTGRES_HOST") or os.getenv("PGHOST", "localhost"),
        "port": os.getenv("POSTGRES_PORT") or os.getenv("PGPORT", "5432"),
        "database": os.getenv("POSTGRES_DB") or os.getenv("PGDATABASE", "hotel_analytics"),
    }

    if not settings["password"]:
        env_hint = ""
        if project_root is not None and not (project_root / ".env").is_file():
            env_hint = f"\nNo .env file at {project_root / '.env'}"
        raise ValueError(
            "Database password not found.\n"
            "Set POSTGRES_PASSWORD / PGPASSWORD in the environment, or create a .env "
            f"file in the project root.{env_hint}"
        )

    return settings


def create_engine_from_settings(project_root: Path | None = None):
    """Build a SQLAlchemy engine (does not open a connection yet)."""
    from sqlalchemy import create_engine

    s = get_db_settings(project_root)
    url = (
        f"postgresql+psycopg2://{s['username']}:{s['password']}"
        f"@{s['host']}:{s['port']}/{s['database']}"
    )
    return create_engine(url)


def verify_connection(engine) -> None:
    """Run SELECT 1 to confirm PostgreSQL accepts the credentials."""
    from sqlalchemy import text

    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))


def connect(project_root: Path | None = None):
    """Create engine and verify a live connection to PostgreSQL."""
    engine = create_engine_from_settings(project_root)
    verify_connection(engine)
    return engine
