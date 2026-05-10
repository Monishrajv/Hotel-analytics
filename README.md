# 🏨 Hotel Revenue Analytics & Management Dashboard

## 📌 Project Overview
This end-to-end data analytics project focuses on hotel revenue management and operational performance. By processing raw booking data through a complete data pipeline—from cleaning and transformation to relational modeling and interactive visualization—this project delivers actionable insights into occupancy trends, pricing strategies, and cancellation impacts. 

The final deliverable is a dynamic Power BI dashboard designed to support stakeholder decision-making and optimize property-level profitability.

## 🛠️ Tech Stack
* **Data Cleaning & Profiling:** Python (Pandas, Jupyter Notebooks)
* **Data Storage & Modeling:** PostgreSQL (Star Schema Architecture)
* **Data Visualization & Analysis:** Power BI (DAX, Interactive Dashboards)
* **Version Control:** Git & GitHub
* **Presentation & Reporting:** Gemma AI / Gamma.app

## 📈 Key Performance Indicators (KPIs) Tracked
This project focuses on industry-standard hospitality metrics to answer core business questions:
* **Occupancy Rate (%):** *(Rooms Occupied ÷ Rooms Available) × 100* – Measures how effectively inventory is utilized.
* **Average Daily Rate (ADR):** *(Total Room Revenue ÷ Number of Rooms Sold)* – Reflects the average price achieved per occupied room.
* **Revenue Per Available Room (RevPAR):** *(ADR × Occupancy%)* – Combines price and occupancy to measure overall revenue maximization.
* **Cancellation Rate (%):** *(Cancelled Reservations ÷ Total Reservations) × 100* – Tracks lost revenue opportunities and operational inefficiencies.
* **Average Length of Stay (ALOS):** *(Total Room Nights Sold ÷ Number of Bookings)* – Helps forecast staffing needs and guest stability.

## 🗄️ Data Architecture (Star Schema)
The data is modeled in PostgreSQL using a denormalized **Star Schema** optimized for analytical queries. 

**Fact Tables:**
* `fact_bookings`: Detailed, transaction-level booking records.
* `fact_aggregated_bookings`: Rolled-up metrics on successful bookings and property capacity.

**Dimension Tables:**
* `dim_hotels`: Property details (Property ID, Name, Category, City).
* `dim_rooms`: Room classifications and IDs.
* `dim_date`: Date details (Month, Week No, Day Type) for time-series analysis.

## 🔄 Project Phases & Methodology

### Phase 1: Data Inventory & Profiling
* Ingested multiple raw CSV files (`fact_bookings.csv`, `dim_hotels.csv`, etc.) using Python and Pandas.
* Profiled datasets for schemas, data types, null values, and anomalies (e.g., negative guest counts, missing ratings).

### Phase 2: Data Cleaning & Transformation
* Standardized date formats using Pandas datetime parsing.
* Cleansed numeric anomalies and handled missing values systematically.
* Computed derived columns, including Length of Stay (nights), Year/Month identifiers, and Boolean status flags (e.g., `is_cancelled`).
* Exported sanitized, analysis-ready datasets.

### Phase 3: Relational Data Modeling
* Designed and deployed a Star Schema database in PostgreSQL.
* Created primary and foreign key constraints to ensure data integrity.
* Bulk-loaded cleaned CSVs into the relational tables using SQL `COPY` commands.

### Phase 4: Data Analysis & Visualization
* Connected Power BI to the PostgreSQL database.
* Established 1-to-many relationships between Dimension and Fact tables.
* Authored DAX measures for complex KPIs (Occupancy %, ADR, RevPAR).
* Developed an interactive dashboard featuring time-series trends, categorical comparisons (by city/hotel class), and KPI scorecards with contextual slicers.

## 📂 Repository Structure

```text
├── data/
│   ├── raw/                 # Original, unmodified CSV files (git-ignored if large)
│   └── clean/               # Processed, analysis-ready CSV files
├── scripts/
│   ├── data_cleaning.ipynb  # Python notebooks for profiling and cleaning
│   └── schema_setup.sql     # PostgreSQL DDL and COPY commands
├── docs/
│   └── presentation.pdf     # Slide deck summarizing findings and methodologies
├── dashboard/
│   └── hotel_analytics.pbix # Power BI project file
├── .gitignore
└── README.md