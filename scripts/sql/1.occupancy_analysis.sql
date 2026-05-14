---KPI 1 — Occupancy % [BUSINESS QUESTION] How efficiently are hotel rooms being utilized?
SELECT
    property_id,
    check_in_date,
    SUM(successful_bookings) AS total_successful_bookings,
    SUM(capacity) AS total_capacity,

    ROUND(
        SUM(successful_bookings) * 100.0
        / SUM(capacity),
        2
    ) AS occupancy_rate

FROM fact_aggregated_bookings

GROUP BY
    property_id,
    check_in_date;