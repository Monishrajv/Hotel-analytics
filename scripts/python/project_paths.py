"""Resolve repository paths for Jupyter notebooks (run from repo root or scripts/python/)."""
from pathlib import Path


def find_project_root() -> Path:
    path = Path.cwd().resolve()
    for _ in range(6):
        if (path / "data").is_dir() and (path / "scripts").is_dir():
            return path
        path = path.parent
    raise FileNotFoundError(
        "Could not find project root. Start Jupyter from the repository root "
        "or from scripts/python/."
    )


ROOT = find_project_root()
DATA_RAW = ROOT / "data" / "raw"
DATA_CLEAN = ROOT / "data" / "clean"
