-- This view standardizes booking data for the BI tool
CREATE OR REPLACE VIEW vw_refined_bookings AS
SELECT 
    b.booking_id,
    b.property_id,
    b.check_in_date,
    b.revenue_generated,
    b.revenue_realized,
    b.booking_status,
    -- Flagging successful vs cancelled for easier DAX
    CASE WHEN b.booking_status = 'Checked Out' THEN 1 ELSE 0 END as is_checked_out,
    CASE WHEN b.booking_status = 'Cancelled' THEN 1 ELSE 0 END as is_cancelled,
    CASE WHEN b.booking_status = 'No Show' THEN 1 ELSE 0 END as is_no_show
FROM fact_bookings b;


-- This view provides the business logic for revenue analysis
CREATE OR REPLACE VIEW vw_property_performance AS
SELECT 
    h.property_name,
    h.city,
    h.category,
    rb.check_in_date,
    SUM(rb.revenue_generated) as total_potential_revenue,
    SUM(rb.revenue_realized) as total_actual_revenue,
    SUM(rb.is_checked_out) as total_completed_bookings,
    SUM(rb.is_cancelled) as total_cancellations
FROM vw_refined_bookings rb
JOIN dim_hotels h ON rb.property_id = h.property_id
GROUP BY h.property_name, h.city, h.category, rb.check_in_date;


-- Quick check: Which cities have the highest cancellation rates?
SELECT 
    city, 
    ROUND(SUM(total_cancellations)::numeric / (SUM(total_completed_bookings) + SUM(total_cancellations)), 4) * 100 as cancellation_rate_pct
FROM vw_property_performance
GROUP BY city
ORDER BY cancellation_rate_pct DESC;