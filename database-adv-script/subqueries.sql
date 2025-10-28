-- Query: Find all properties where the average rating is greater than 4.0
SELECT 
    p.property_id,
    p.title,
    p.city,
    p.price_per_night
FROM properties p
WHERE (
    SELECT AVG(r.rating)
    FROM bookings b
    JOIN reviews r ON b.booking_id = r.booking_id
    WHERE b.property_id = p.property_id
) > 4.0;

-- Query: Correlated subquery to find users who have made more than 3 bookings

SELECT 
    u.user_id,
    u.full_name,
    u.email
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.guest_id = u.user_id
) > 3;

