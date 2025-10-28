
# ⚡ SQL Query Performance Optimization Report

## 📘 Overview
This report documents the performance analysis and optimization of a complex SQL query that retrieves **booking details** alongside **user**, **property**, and **payment** information from the **Airbnb database schema**.

The goal was to identify inefficiencies, measure performance, and refactor the query for improved execution time.

---

## 🧩 Step 1: Initial Query

The initial query joins four tables:

```sql
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
