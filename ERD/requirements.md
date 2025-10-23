# 🏠 AirBnB Database ER Diagram

This Entity-Relationship Diagram (ERD) represents the core structure of an **AirBnB-style platform** — showing relationships among `User`, `Property`, `Booking`, `Payment`, `Review`, and `Message` entities.


```mermaid
    erDiagram

    %% =====================
    %% ENTITY DEFINITIONS
    %% =====================

    %% --- USER ---
    User {
        UUID user_id PK
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR email
        VARCHAR password_hash
        VARCHAR phone_number
        VARCHAR role
        TIMESTAMP created_at
    }

    %% --- PROPERTY ---
    Property {
        UUID property_id PK
        UUID host_id FK
        VARCHAR name
        TEXT description
        VARCHAR location
        DECIMAL price_per_night
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }

    %% --- BOOKING ---
    Booking {
        UUID booking_id PK
        UUID property_id FK
        UUID user_id FK
        DATE start_date
        DATE end_date
        DECIMAL total_price
        VARCHAR status
        TIMESTAMP created_at
    }

    %% --- PAYMENT ---
    Payment {
        UUID payment_id PK
        UUID booking_id FK
        DECIMAL amount
        TIMESTAMP payment_date
        VARCHAR payment_method
    }

    %% --- REVIEW ---
    Review {
        UUID review_id PK
        UUID property_id FK
        UUID user_id FK
        INTEGER rating
        TEXT comment
        TIMESTAMP created_at
    }

    %% --- MESSAGE ---
    Message {
        UUID message_id PK
        UUID sender_id FK
        UUID recipient_id FK
        TEXT message_body
        TIMESTAMP sent_at
    }

    %% =====================
    %% RELATIONSHIPS
    %% =====================

    %% USER RELATIONSHIPS
    User ||--o{ Property : "hosts"
    User ||--o{ Booking : "makes"
    User ||--o{ Review : "writes"
    User ||--o{ Message : "sends"
    User ||--o{ Message : "receives"

    %% PROPERTY RELATIONSHIPS
    Property ||--o{ Booking : "is booked for"
    Property ||--o{ Review : "receives"

    %% BOOKING RELATIONSHIPS
    Booking ||--|| Payment : "has"
```
