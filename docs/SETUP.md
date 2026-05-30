# Setup Guide

Follow these steps to reproduce the Hotel Revenue Analytics pipeline on your machine.

## Prerequisites

- **Python 3.10+**
- **PostgreSQL 14+** (local install)
- **Power BI Desktop** (for the dashboard; optional for SQL-only workflow)
- **Git**

## 1. Clone and create a virtual environment

```bash
git clone https://github.com/YOUR_USERNAME/Hotel-analytics.git
cd Hotel-analytics

python -m venv .venv

# Windows
.venv\Scripts\activate

# macOS / Linux
source .venv/bin/activate

pip install -r requirements.txt
```

## 2. Configure PostgreSQL

Create the database (psql or pgAdmin):

```sql
CREATE DATABASE hotel_analytics;
```

### Database credentials (choose one)

**Option A — Global / user environment variables (no `.env` file)**

Set these in Windows **Environment Variables** (or your shell profile). Notebook 3 reads them automatically:

| Variable | Example |
|----------|---------|
| `POSTGRES_USER` | `postgres` |
| `POSTGRES_PASSWORD` or `PGPASSWORD` | your PostgreSQL password |
| `POSTGRES_HOST` | `localhost` |
| `POSTGRES_PORT` | `5432` |
| `POSTGRES_DB` | `hotel_analytics` |

PowerShell (current session only):

```powershell
$env:POSTGRES_USER = "postgres"
$env:POSTGRES_PASSWORD = "your_password"
$env:POSTGRES_DB = "hotel_analytics"
```

**Option B — Local `.env` file (optional)**

```bash
copy .env.example .env    # Windows
cp .env.example .env      # macOS / Linux
```

Edit `.env` with your credentials. The file is git-ignored. Works without `python-dotenv` (built-in parser in `db_config.py`).

## 3. Run the pipeline (in order)

| Step | Artifact | Action |
|------|----------|--------|
| 1 | `scripts/python/1.Hotel_analysis data explaoration.ipynb` | Profile raw CSVs in `data/raw/` |
| 2 | `scripts/python/2.Hotel_analysis data cleaning.ipynb` | Clean data → `data/clean/` |
| 3 | `scripts/python/3.Hotel_analysis data load to postgresql.ipynb` | Load tables into PostgreSQL |
| 4 | `scripts/sql/hotel-analytics-data-modeling.sql` | Types, keys, repair `dim_date` |
| 5 | `scripts/sql/1.occupancy_analysis.sql` … `6.City-Analysis.sql` | Validate KPIs |
| 6 | `scripts/sql/create-view-in-hospitality-kpis.sql` | BI-friendly views |
| 7 | `powerbi/hotel_anlytics_dashboard_BI.pbix` | Connect to PostgreSQL, refresh |

**Jupyter tip:** Start Jupyter from the **repository root** so paths resolve correctly:

```bash
jupyter notebook
```

## 4. Power BI connection

1. Open `powerbi/hotel_anlytics_dashboard_BI.pbix`.
2. **Transform data → Data source settings** → point to your PostgreSQL instance.
3. Use the same database name as `POSTGRES_DB` in `.env` (default: `hotel_analytics`).
4. Refresh the model after SQL modeling and views are applied.

## 5. Verify PostgreSQL (real connection test)

`create_engine()` alone does **not** connect. Use this after setting `POSTGRES_PASSWORD`:

```powershell
$env:POSTGRES_PASSWORD = "your_password"
python -c "import sys; sys.path.insert(0,'scripts/python'); from db_config import connect; from project_paths import ROOT; connect(ROOT); print('Real PostgreSQL connection: OK')"
```

Wrong password, stopped server, or missing `hotel_analytics` database → this command **errors** (expected).

## 6. Troubleshooting

| Issue | Fix |
|-------|-----|
| `Project root not found` | Run notebooks from repo root or `scripts/python/` |
| `POSTGRES_PASSWORD is not set` | Set user env vars (Option A) or create `.env` (Option B) |
| Says OK but notebook load fails | Use `connect()` test above; engine-only checks are not enough |
| Power BI date relationship errors | Run `hotel-analytics-data-modeling.sql` (fills missing 2022 dates) |
| Missing `fact_bookings.csv` | Use files in `data/raw/` from the repository |

## Data note

Datasets represent a fictional **Atliq** hotel chain (educational / portfolio sample). See [DATA_DICTIONARY.md](DATA_DICTIONARY.md) for column definitions.
