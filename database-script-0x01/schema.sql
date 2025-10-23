-- airbnb_schema.sql
-- Defines the database structure for the AirBnB application, including tables,
-- primary keys, foreign keys, constraints, and performance indexes.

------------------------------------------
-- 1. USER TABLE
------------------------------------------

-- The User table stores information about guests, hosts, and administrators.
CREATE TYPE user_role AS ENUM ('guest', 'host', 'admin');

CREATE TABLE "User" (
    user_id         UUID PRIMARY KEY,
    first_name      VARCHAR(255) NOT NULL,
    last_name       VARCHAR(255) NOT NULL,
    email           VARCHAR(255) UNIQUE NOT NULL, -- Unique constraint as specified
    password_hash   VARCHAR(255) NOT NULL,
    phone_number    VARCHAR(50), -- NULLable
    role            user_role NOT NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Additional Index on email for fast lookups (as specified)
CREATE UNIQUE INDEX idx_user_email ON "User" (email);


------------------------------------------
-- 2. PROPERTY TABLE
------------------------------------------

CREATE TABLE Property (
    property_id     UUID PRIMARY KEY,
    -- Foreign Key: Links the property back to the User who is the host
    host_id         UUID NOT NULL REFERENCES "User"(user_id),
    name            VARCHAR(255) NOT NULL,
    description     TEXT NOT NULL,
    location        VARCHAR(255) NOT NULL,
    pricepernight   DECIMAL(10, 2) NOT NULL CHECK (pricepernight >= 0),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index on host_id to optimize lookups for a host's properties
CREATE INDEX idx_property_host_id ON Property (host_id);


------------------------------------------
-- 3. BOOKING TABLE
------------------------------------------

CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');

CREATE TABLE Booking (
    booking_id      UUID PRIMARY KEY,
    -- Foreign Key: Links the booking to the specific property
    property_id     UUID NOT NULL REFERENCES Property(property_id),
    -- Foreign Key: Links the booking to the User (guest) who made it
    user_id         UUID NOT NULL REFERENCES "User"(user_id),
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    total_price     DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0),
    status          booking_status NOT NULL, -- ENUM constraint
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraint to ensure the start date precedes the end date
    CONSTRAINT chk_booking_dates CHECK (start_date < end_date)
);

-- Indexes for performance (as specified)
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_booking_user_id ON Booking (user_id);


------------------------------------------
-- 4. PAYMENT TABLE
------------------------------------------

CREATE TYPE payment_method AS ENUM ('credit_card', 'paypal', 'stripe');

CREATE TABLE Payment (
    payment_id      UUID PRIMARY KEY,
    -- Foreign Key: Links the payment to the corresponding booking
    booking_id      UUID UNIQUE NOT NULL REFERENCES Booking(booking_id),
    amount          DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    payment_date    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    payment_method  payment_method NOT NULL -- ENUM constraint
);

-- Index for payment lookups based on booking_id (as specified)
-- Note: booking_id is already implicitly indexed due to the UNIQUE constraint, 
-- but we include the explicit request for clarity if it were not unique.
CREATE INDEX idx_payment_booking_id ON Payment (booking_id);


------------------------------------------
-- 5. REVIEW TABLE
------------------------------------------

CREATE TABLE Review (
    review_id       UUID PRIMARY KEY,
    -- Foreign Key: Property being reviewed
    property_id     UUID NOT NULL REFERENCES Property(property_id),
    -- Foreign Key: User (guest) submitting the review
    user_id         UUID NOT NULL REFERENCES "User"(user_id),
    -- Constraint: Rating must be between 1 and 5 (inclusive)
    rating          INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment         TEXT NOT NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Optional: Ensure a user can only review a property once (and only after a stay)
    -- This constraint is often handled at the application level to check booking status.
    CONSTRAINT unique_user_property_review UNIQUE (user_id, property_id) 
);

-- Indexes for fast lookups by property or reviewer
CREATE INDEX idx_review_property_id ON Review (property_id);
CREATE INDEX idx_review_user_id ON Review (user_id);


------------------------------------------
-- 6. MESSAGE TABLE
------------------------------------------

CREATE TABLE Message (
    message_id      UUID PRIMARY KEY,
    -- Foreign Key: User who sent the message
    sender_id       UUID NOT NULL REFERENCES "User"(user_id),
    -- Foreign Key: User who received the message
    recipient_id    UUID NOT NULL REFERENCES "User"(user_id),
    message_body    TEXT NOT NULL,
    sent_at         TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for efficient message retrieval (e.g., all messages for a user)
CREATE INDEX idx_message_sender_id ON Message (sender_id);
CREATE INDEX idx_message_recipient_id ON Message (recipient_id);
CREATE INDEX idx_message_sent_at ON Message (sent_at);

-- Optional: Index for fast lookups of conversations between two specific users
CREATE INDEX idx_message_conversation ON Message (sender_id, recipient_id);

