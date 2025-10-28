# ⚙️ SQL Performance Profiling and Optimization Report

## 📘 Overview
This report analyzes query performance in the **Airbnb-like database schema** using `SHOW PROFILE` and `EXPLAIN ANALYZE`.  
The goal was to detect bottlenecks, apply schema/index improvements, and measure performance gains.

---

## 🧩 Step 1: Baseline Query

A commonly used query retrieves confirmed bookings along with user and property details:

```sql
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
