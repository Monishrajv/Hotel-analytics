--Booking Platform Analysis
SELECT
    booking_platform,

    COUNT(*) AS total_bookings,

    SUM(revenue_realized) AS revenue

FROM fact_bookings

WHERE booking_status = 'Checked Out'

GROUP BY booking_platform

ORDER BY revenue DESC;