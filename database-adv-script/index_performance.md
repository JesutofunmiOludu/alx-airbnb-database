# 🗃️ Database Index Optimization Documentation

## 📘 Overview
This document explains how indexes were identified, created, and tested to improve the performance of SQL queries in the **Airbnb database schema** (`users`, `bookings`, `properties`, `reviews`).

Indexes help the database quickly locate and access the data without scanning every row in a table — improving the speed of `WHERE`, `JOIN`, and `ORDER BY` operations.

---

## 🔍 Step 1: Identify High-Usage Columns

After reviewing all major queries used in the Airbnb schema, the following columns were identified as high-usage due to their frequent appearance in `WHERE`, `JOIN`, and `ORDER BY` clauses:

| Table | Column | Reason for Indexing | Example Usage |
|--------|---------|--------------------|----------------|
| `users` | `user_id` | Used in joins with bookings | `ON users.user_id = bookings.guest_id` |
| `bookings` | `guest_id` | To filter bookings by user | `WHERE guest_id = ?` |
| `bookings` | `property_id` | To find all bookings for a property | `WHERE property_id = ?` |
| `properties` | `city` | Used for location-based searches | `WHERE city = 'Lagos'` |
| `reviews` | `booking_id` | Used in joins with bookings | `ON reviews.booking_id = bookings.booking_id` |

---

## ⚙️ Step 2: Create Indexes

Below are the SQL commands used to create the appropriate indexes.  
These commands are stored in the file: **`database_index.sql`**

```sql
-- database_index.sql

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

