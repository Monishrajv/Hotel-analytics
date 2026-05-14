---RevPAR [BUSINESS QUESTION]  How much revenue is generated per available room?
SELECT
    fab.property_id,
    fab.check_in_date,

    SUM(fb.revenue_realized) AS revenue,

    SUM(fab.capacity) AS capacity,

    ROUND(
        SUM(fb.revenue_realized)
        / NULLIF(SUM(fab.capacity),0),
        2
    ) AS revpar

FROM fact_bookings fb

JOIN fact_aggregated_bookings fab
ON fb.property_id = fab.property_id
AND fb.check_in_date = fab.check_in_date

WHERE fb.booking_status = 'Checked Out'

GROUP BY
    fab.property_id,
    fab.check_in_date;