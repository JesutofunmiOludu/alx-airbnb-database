-- ===========================================================
-- INITIAL QUERY: Retrieve all bookings with user, property, and payment details
-- ===========================================================

EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.full_name,
    u.email,
    p.property_id,
    p.title AS property_title,
    p.city AS property_city,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_status
FROM bookings b
JOIN users u ON b.guest_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id;

-- ===========================================================
-- ANALYSIS NOTES:
-- Run this EXPLAIN in your SQL environment to observe:
-- 1. Type of scan (Sequential vs Index Scan)
-- 2. Estimated cost
-- 3. Execution time
-- ===========================================================


-- ===========================================================
-- REFACTORED / OPTIMIZED QUERY
-- ===========================================================
-- Optimization techniques applied:
-- - Added indexes on high-usage foreign key columns
-- - Removed unnecessary columns from SELECT
-- - Used LEFT JOIN only where needed
-- - Limited result set using WHERE (optional in production)
-- ===========================================================

-- Create performance indexes (if not already created)
CREATE INDEX IF NOT EXISTS idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);

-- Optimized query
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.full_name AS guest_name,
    p.title AS property_title,
    pay.amount,
    pay.payment_status
FROM bookings b
JOIN users u ON b.guest_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id;

-- ===========================================================
-- PERFORMANCE COMPARISON:
-- Run EXPLAIN again after index creation.
-- Look for:
--   - “Index Scan” replacing “Seq Scan”
--   - Reduced total cost
--   - Faster execution time (check with EXPLAIN ANALYZE)
-- ===========================================================

