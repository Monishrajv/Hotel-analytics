--City Analysis
SELECT
    dh.city,

    SUM(fb.revenue_realized) AS revenue,

    AVG(fb.ratings_given) AS avg_rating

FROM fact_bookings fb

JOIN dim_hotels dh
ON fb.property_id = dh.property_id

WHERE fb.booking_status = 'Checked Out'

GROUP BY dh.city

ORDER BY revenue DESC;