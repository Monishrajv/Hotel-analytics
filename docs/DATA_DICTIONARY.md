# Data Dictionary

**Source:** Educational sample data for a fictional multi-city hotel chain (**Atliq**).  
**Period:** Check-ins primarily **May–July 2022**.  
**Grain:** Booking-level facts + daily aggregated capacity.

---

## `fact_bookings` / `fact_bookings_clean.csv`

| Column | Type | Description |
|--------|------|-------------|
| `booking_id` | string | Unique booking identifier |
| `property_id` | int | FK → `dim_hotels.property_id` |
| `booking_date` | date | Date reservation was made |
| `check_in_date` | date | Arrival date |
| `checkout_date` | date | Departure date |
| `no_guests` | int | Guest count (invalid ≤0 rows removed in cleaning) |
| `room_category` | string | Room class: RT1, RT2, RT3, RT4 |
| `booking_platform` | string | Channel: others, makeyourtrip, logtrip, direct online, etc. |
| `ratings_given` | float | Guest rating (nullable; ~58% missing) |
| `booking_status` | string | Checked Out, Cancelled, No Show |
| `revenue_generated` | numeric | Potential revenue at booking |
| `revenue_realized` | numeric | Actual revenue recognized |

**Rows:** ~134,590 raw → **134,573** clean

---

## `fact_aggregated_bookings` / `fact_aggregated_bookings_clean.csv`

| Column | Type | Description |
|--------|------|-------------|
| `property_id` | int | FK → `dim_hotels` |
| `check_in_date` | date | Stay date |
| `room_category` | string | RT1–RT4 |
| `successful_bookings` | int | Count of successful bookings for that day/room |
| `capacity` | numeric | Available room capacity (2 nulls imputed with median in cleaning) |
| `occ_rate` | float | Occupancy rate (present in clean export) |

**Rows:** ~9,200 raw → **9,194** clean

---

## `dim_hotels` / `dim_hotels_clean.csv`

| Column | Type | Description |
|--------|------|-------------|
| `property_id` | int | Primary key |
| `property_name` | string | e.g. Atliq Grands, Atliq Palace |
| `category` | string | Luxury or Business |
| `city` | string | Delhi, Mumbai, Bangalore, Hyderabad |

**Rows:** **25** properties

---

## `dim_rooms` / `dim_rooms_clean.csv`

| Column | Type | Description |
|--------|------|-------------|
| `room_id` | string | RT1, RT2, RT3, RT4 |
| `room_class` | string | Room class label |

**Rows:** **4**

---

## `dim_date` / `dim_date_clean.csv`

| Column | Type | Description |
|--------|------|-------------|
| `date` | date | Calendar date |
| `week no` | int | ISO-style week number |
| `day_type` | string | weekday or weekend |

**Note:** April 2022 gaps in the raw file are filled in PostgreSQL via `generate_series` in `hotel-analytics-data-modeling.sql`.

---

## KPI definitions (SQL / Power BI)

| KPI | Formula |
|-----|---------|
| Occupancy % | `SUM(successful_bookings) / SUM(capacity) × 100` |
| ADR | `SUM(revenue_realized) / SUM(successful_bookings)` (Checked Out) |
| RevPAR | `SUM(revenue_realized) / SUM(capacity)` (Checked Out) |
| Cancellation % | `COUNT(Cancelled) / COUNT(*) × 100` per property |
| Realisation % | `revenue_realized / revenue_generated` (context-dependent filters in BI) |
