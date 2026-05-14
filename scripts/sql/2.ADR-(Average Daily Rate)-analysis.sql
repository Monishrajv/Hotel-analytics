---ADR (Average Daily Rate) [BUSINESS QUESTION] What is average revenue earned per sold room?
SELECT
    fab.property_id,
    fab.check_in_date,

    SUM(fb.revenue_realized) AS total_revenue,

    SUM(fab.successful_bookings) AS sold_rooms, ROUND(
        SUM(fb.revenue_realized)
        / NULLIF(SUM(fab.successful_bookings), 0),
        2
    ) AS adr

FROM fact_bookings fb

JOIN fact_aggregated_bookings fab
ON fb.property_id = fab.property_id
AND fb.check_in_date = fab.check_in_date

WHERE fb.booking_status = 'Checked Out'

GROUP BY
    fab.property_id,
    fab.check_in_date;

SELECT *
FROM fact_bookings;

SELECT *
FROM fact_aggregated_bookings;