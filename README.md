# Hotel Revenue Analytics & Management Dashboard

End-to-end hospitality analytics for a fictional **Atliq** hotel chain: clean **134K+ bookings** in Python, model a **PostgreSQL star schema**, validate **six industry KPIs** in SQL, and explore results in an interactive **Power BI** dashboard.

[![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)](https://www.python.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791.svg)](https://www.postgresql.org/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811.svg)](https://powerbi.microsoft.com/)

---

## Problem & solution

**Problem:** Multi-property hotels need a single view of occupancy, pricing, cancellations, and channel performance—raw bookings alone do not answer revenue-management questions.

**Solution:** A reproducible pipeline from CSV → cleaned tables → PostgreSQL → SQL KPIs → Power BI, with documented findings and portfolio-ready artifacts.

**Impact (May–Jul 2022 analysis window):**

- Portfolio **occupancy ~58%**, **ADR ~12.7K**, **RevPAR ~7.4K**, **realisation ~70%**
- **~25% cancellation rate** per property—major revenue leakage
- **Mumbai** leads revenue (~₹552M); **Delhi** leads guest ratings (~3.78)
- **Luxury** segment ~**62%** of realized revenue vs Business ~**38%**

---

## Dashboard preview

![Power BI Dashboard](screenshots/BI%20dashboard.png)

| Occupancy by property | Cancellation rate |
|:---:|:---:|
| ![KPI 1](screenshots/KPI%201%20%E2%80%94%20Occupancy%20%25.png) | ![KPI 4](screenshots/KPI%204%20-%20cancellation%20rate%20analysis.png) |

More SQL outputs: [`screenshots/`](screenshots/)

---

## Tech stack

| Layer | Tools |
|-------|--------|
| Profiling & ETL | Python, Pandas, Jupyter |
| Database | PostgreSQL, SQLAlchemy |
| Analytics | SQL (6 KPI scripts + views) |
| Visualization | Power BI, DAX |
| Version control | Git, GitHub |

---

## Repository structure

```text
Hotel-analytics/
├── data/
│   ├── raw/                    # Original CSVs
│   └── clean/                  # Cleaned exports from notebook 2
├── docs/
│   ├── SETUP.md                # Installation & run order
│   ├── DATA_DICTIONARY.md      # Column definitions
│   └── Hotel_Revenue_Analytics_Project_Report.md
├── powerbi/
│   └── hotel_anlytics_dashboard_BI.pbix
├── screenshots/                # Dashboard + SQL result captures
├── scripts/
│   ├── python/
│   │   ├── 1.Hotel_analysis data explaoration.ipynb
│   │   ├── 2.Hotel_analysis data cleaning.ipynb
│   │   ├── 3.Hotel_analysis data load to postgresql.ipynb
│   │   └── project_paths.py    # Portable path helper
│   └── sql/
│       ├── hotel-analytics-data-modeling.sql
│       ├── 1.occupancy_analysis.sql … 6.City-Analysis.sql
│       └── create-view-in-hospitality-kpis.sql
├── .env.example
├── requirements.txt
└── README.md
```

---

## Quick start

```bash
git clone https://github.com/YOUR_USERNAME/Hotel-analytics.git
cd Hotel-analytics
python -m venv .venv && .venv\Scripts\activate   # Windows
pip install -r requirements.txt
# Set POSTGRES_PASSWORD as a user env var, or optionally copy .env.example → .env
```

Full steps: **[docs/SETUP.md](docs/SETUP.md)**

**Run order:** Notebook 1 → 2 → 3 → SQL modeling → KPI scripts → Power BI refresh.

---

## KPIs tracked

| KPI | Business question |
|-----|-------------------|
| **Occupancy %** | Are we filling rooms efficiently? |
| **ADR** | What price are we achieving per sold room? |
| **RevPAR** | How much revenue per available room? |
| **Cancellation %** | Where is revenue leaking? |
| **Platform mix** | Which booking channels drive revenue? |
| **City performance** | Which markets and ratings stand out? |

---

## Data source

Sample **educational hospitality booking data** for portfolio and learning purposes (fictional **Atliq** brand). Not affiliated with any real hotel group.

---

## Documentation

- **[Project report](docs/Hotel_Revenue_Analytics_Project_Report.md)** — Full write-up (overview, EDA, SQL results, recommendations)
- **[Data dictionary](docs/DATA_DICTIONARY.md)**
- **[Setup guide](docs/SETUP.md)**

---

## Security

Database credentials come from **OS/user environment variables** (recommended for local work) or an optional **`.env`** file (see `.env.example`). Never commit `.env`. If a password was ever pushed to a public remote, rotate your PostgreSQL password.

---

## License

[MIT](LICENSE) — free to use with attribution.

---

## Author

**Monish** — Data analytics portfolio project (2026)
