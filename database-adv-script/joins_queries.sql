CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,                -- Unique identifier
    full_name VARCHAR(100) NOT NULL,           -- User's full name
    email VARCHAR(100) UNIQUE NOT NULL,        -- Must be unique
    password_hash VARCHAR(255) NOT NULL,       -- Encrypted password
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW(),        -- Timestamp of registration
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE properties (
    property_id SERIAL PRIMARY KEY,
    host_id INT NOT NULL,                                  -- FK to users
    title VARCHAR(150) NOT NULL,
    description TEXT,
    property_type VARCHAR(50),                             -- e.g. Apartment, Villa
    address VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100),
    price_per_night DECIMAL(10,2) NOT NULL CHECK (price_per_night > 0),
    max_guests INT DEFAULT 1 CHECK (max_guests > 0),
    created_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_host FOREIGN KEY (host_id)
        REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    guest_id INT NOT NULL,                                  -- FK to users
    property_id INT NOT NULL,                               -- FK to properties
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    status VARCHAR(20) DEFAULT 'pending',                   -- pending, confirmed, cancelled
    created_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_guest FOREIGN KEY (guest_id)
        REFERENCES users(user_id) ON DELETE CASCADE,

    CONSTRAINT fk_property FOREIGN KEY (property_id)
        REFERENCES properties(property_id) ON DELETE CASCADE,

    CONSTRAINT chk_dates CHECK (end_date > start_date)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL UNIQUE,                 -- 1 review per booking
    reviewer_id INT NOT NULL,                       -- FK to users
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_booking FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id) ON DELETE CASCADE,

    CONSTRAINT fk_reviewer FOREIGN KEY (reviewer_id)
        REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert Sample Data — users

INSERT INTO users (full_name, email, password_hash, phone_number)
VALUES
('Alice Johnson', 'alice@example.com', 'hashed_pw_1', '+2348011111111'),
('John Doe', 'john@example.com', 'hashed_pw_2', '+2348022222222'),
('Maria Gomez', 'maria@example.com', 'hashed_pw_3', '+2348033333333'),
('David Lee', 'david@example.com', 'hashed_pw_4', '+2348044444444'),
('Sandra Okoro', 'sandra@example.com', 'hashed_pw_5', '+2348055555555');

-- Insert Sample Data — properties

INSERT INTO properties (host_id, title, description, property_type, address, city, country, price_per_night, max_guests)
VALUES
(1, 'Cozy Apartment in Lagos', 'Modern 2-bedroom apartment close to the beach.', 'Apartment', '12 Banana Island Road', 'Lagos', 'Nigeria', 45000, 4),
(2, 'Luxury Villa in Abuja', 'Spacious villa with a pool and beautiful garden.', 'Villa', '45 Maitama Avenue', 'Abuja', 'Nigeria', 120000, 8),
(1, 'Studio Flat in Port Harcourt', 'Simple and clean flat for business travelers.', 'Studio', '8 Rumuola Street', 'Port Harcourt', 'Nigeria', 25000, 2);

-- Insert Sample Data — bookings

INSERT INTO bookings (guest_id, property_id, start_date, end_date, total_price, status)
VALUES
(3, 1, '2025-11-01', '2025-11-05', 180000, 'confirmed'),  -- Maria booked Alice’s apartment
(4, 2, '2025-11-10', '2025-11-15', 600000, 'confirmed'),  -- David booked John’s villa
(5, 1, '2025-12-01', '2025-12-03', 90000, 'pending');     -- Sandra booked Alice’s apartment


-- INNER JOIN: Retrieve all bookings and the respective users who made those bookings.
SELECT 
    b.booking_id,
    u.user_id,
    u.full_name AS guest_name,
    u.email AS guest_email,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM bookings b
INNER JOIN users u 
    ON b.guest_id = u.user_id;

-- Insert Sample Data — reviews

INSERT INTO reviews (booking_id, reviewer_id, rating, comment)
VALUES
(1, 3, 5, 'Amazing apartment! Very clean and close to the beach.'),
(2, 4, 4, 'Beautiful villa with great amenities, but a bit far from the city center.');


-- LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews.
SELECT 
    p.property_id,
    p.title AS property_title,
    p.city,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at
FROM properties p
LEFT JOIN bookings b 
    ON p.property_id = b.property_id
LEFT JOIN reviews r 
    ON b.booking_id = r.booking_id;

-- FULL OUTER JOIN: Retrieve all users and all bookings

SELECT 
    u.user_id,
    u.full_name AS user_name,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM users u
FULL OUTER JOIN bookings b 
    ON u.user_id = b.guest_id;

