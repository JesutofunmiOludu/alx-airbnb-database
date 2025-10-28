-- 1️⃣ User table
CREATE INDEX idx_users_user_id ON users(user_id);

-- 2️⃣ Bookings table
CREATE INDEX idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_guest_property ON bookings(guest_id, property_id);

-- 3️⃣ Properties table
CREATE INDEX idx_properties_city ON properties(city);

-- 4️⃣ Reviews table
CREATE INDEX idx_reviews_booking_id ON reviews(booking_id);
-- Measure Performance
EXPLAIN
SELECT u.full_name, b.booking_id, b.start_date, b.end_date
FROM users u
JOIN bookings b ON u.user_id = b.guest_id
WHERE u.user_id = 3;
