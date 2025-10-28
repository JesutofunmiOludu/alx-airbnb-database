
-- ===========================================================
-- STEP 1: Enable SQL profiling
-- ===========================================================
-- (MySQL and MariaDB)
SET profiling = 1;

-- ===========================================================
-- STEP 2: Run a frequently used query (baseline performance)
-- ===========================================================
-- Retrieve bookings with user and property details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.full_name,
    p.title AS property_title
FROM bookings b
JOIN users u ON b.guest_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
ORDER BY b.start_date DESC;

-- View profiling results
SHOW PROFILES;

-- Get detailed performance breakdown for the last query
SHOW PROFILE FOR QUERY 1;

-- ===========================================================
-- STEP 3: Analyze the query execution plan
-- ===========================================================
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.full_name,
    p.title AS property_title
FROM bookings b
JOIN users u ON b.guest_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
ORDER BY b.start_date DESC;

-- ===========================================================
-- STEP 4: Identify bottlenecks
-- Typical findings from SHOW PROFILE or EXPLAIN ANALYZE:
-- - High time in "Sending data" → missing index on ORDER BY or WHERE
-- - "Creating temporary table" → sorting or grouping inefficiency
-- - "Copying to tmp table on disk" → insufficient indexes or large joins
-- ===========================================================

-- ===========================================================
-- STEP 5: Implement performance improvements
-- ===========================================================
-- Create new indexes to reduce full-table scans
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_start_date ON bookings(start_date);
CREATE INDEX IF NOT EXISTS idx_users_user_id ON users(user_id);
CREATE INDEX IF NOT EXISTS idx_properties_property_id ON properties(property_id);

-- Optional schema change (denormalization or caching)
-- Add a derived column to store property_city for faster lookups
ALTER TABLE bookings ADD COLUMN property_city_cached VARCHAR(255);
UPDATE bookings b
JOIN properties p ON b.property_id = p.property_id
SET b.property_city_cached = p.city;

-- ===========================================================
-- STEP 6: Rerun the optimized query
-- ===========================================================
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.full_name,
    p.title AS property_title
FROM bookings b
JOIN users u ON b.guest_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
ORDER BY b.start_date DESC;

-- ===========================================================
-- STEP 7: Compare results before and after
-- Observe differences in:
--  - Query execution time
--  - Index usage (Index Scan vs Seq Scan)
--  - Temporary table creation
-- ===========================================================

-- View final profiling summary
SHOW PROFILES;
SHOW PROFILE FOR QUERY 2;

SET profiling = 0;
