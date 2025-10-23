-- sample_data.sql
-- Inserts sample data into the AirBnB database schema.
-- NOTE: Uses placeholder UUIDs (formatted as strings) for simplicity and readability.
-- These strings must be valid UUID formats (e.g., in PostgreSQL) when executed.

-- UUID References for Sample Data (for cross-referencing):
-- Users:
--   - host_user_id = 'a0000000-0000-0000-0000-000000000001'
--   - guest1_user_id = 'a0000000-0000-0000-0000-000000000002'
--   - guest2_user_id = 'a0000000-0000-0000-0000-000000000003'
-- Properties:
--   - property1_id = 'b0000000-0000-0000-0000-000000000001'
--   - property2_id = 'b0000000-0000-0000-0000-000000000002'
-- Bookings:
--   - booking1_id = 'c0000000-0000-0000-0000-000000000001'
--   - booking2_id = 'c0000000-0000-0000-0000-000000000002'
-- Payments:
--   - payment1_id = 'd0000000-0000-0000-0000-000000000001'
--   - payment2_id = 'd0000000-0000-0000-0000-000000000002'
-- Reviews:
--   - review1_id = 'e0000000-0000-0000-0000-000000000001'
--   - review2_id = 'e0000000-0000-0000-0000-000000000002'


-- 1. USER TABLE INSERTS
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
('a0000000-0000-0000-0000-000000000001', 'Alice', 'Hostington', 'alice.host@example.com', 'hashed_pass_alice', '555-1234', 'host', NOW() - INTERVAL '6 months'),
('a0000000-0000-0000-0000-000000000002', 'Bob', 'Traveler', 'bob.guest@example.com', 'hashed_pass_bob', '555-5678', 'guest', NOW() - INTERVAL '3 months'),
('a0000000-0000-0000-0000-000000000003', 'Charlie', 'Vacationer', 'charlie.v@example.com', 'hashed_pass_charlie', NULL, 'guest', NOW() - INTERVAL '1 month');


-- 2. PROPERTY TABLE INSERTS
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'Sunny Beach Condo', 'A bright condo right on the beach, perfect for families.', 'Miami, FL', 150.00, NOW() - INTERVAL '5 months', NOW()),
('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'Mountain View Cabin', 'Cozy cabin retreat with stunning views and a hot tub.', 'Aspen, CO', 300.50, NOW() - INTERVAL '4 months', NOW());


-- 3. BOOKING TABLE INSERTS
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
-- Booking 1 (Confirmed) - Guest Bob books the Beach Condo for 5 nights @ $150/night = $750
('c0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', '2025-11-01', '2025-11-06', 750.00, 'confirmed', NOW() - INTERVAL '2 months'),
-- Booking 2 (Pending) - Guest Charlie books the Mountain Cabin for 3 nights @ $300.50/night = $901.50
('c0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000003', '2026-01-10', '2026-01-13', 901.50, 'pending', NOW() - INTERVAL '2 weeks');


-- 4. PAYMENT TABLE INSERTS
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
-- Payment for Confirmed Booking 1
('d0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 750.00, NOW() - INTERVAL '2 months' + INTERVAL '1 hour', 'credit_card'),
-- Payment for Pending Booking 2 (Assuming partial payment or pre-authorization)
('d0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000002', 450.75, NOW() - INTERVAL '2 weeks' + INTERVAL '1 hour', 'paypal');


-- 5. REVIEW TABLE INSERTS
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
-- Review 1 - Bob reviews Property 1 (assuming Bob has completed a previous stay not shown in the booking table)
('e0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 5, 'Absolutely fantastic location and spotless property! Highly recommend.', NOW() - INTERVAL '1 month'),
-- Review 2 - Charlie reviews Property 2 (assuming Charlie has completed a previous stay)
('e0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000003', 4, 'Great views, but the hot tub took a long time to heat up.', NOW() - INTERVAL '2 weeks');


-- 6. MESSAGE TABLE INSERTS
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Message 1: Guest Bob asks Host Alice a question
('f0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'Hi Alice, is there an extra beach umbrella available at the condo?', NOW() - INTERVAL '1 day'),
-- Message 2: Host Alice replies to Guest Bob
('f0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'Yes, Bob! It is in the storage closet on the balcony.', NOW() - INTERVAL '1 day' + INTERVAL '30 minutes'),
-- Message 3: Guest Charlie messages Guest Bob (example of guest-to-guest contact, though less common)
('f0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000002', 'Hey, did you leave a phone charger at the Aspen cabin last week?', NOW() - INTERVAL '10 hours');

