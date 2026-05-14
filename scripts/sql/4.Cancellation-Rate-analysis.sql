---Cancellation Rate
SELECT
    property_id,

    COUNT(
        CASE
            WHEN booking_status = 'Cancelled'
            THEN 1
        END
    ) * 100.0
    / COUNT(*) AS cancellation_rate

FROM fact_bookings

GROUP BY property_id;