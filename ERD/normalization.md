# 💾 Normalization Assessment: AirBnB Database Schema

## Objective

The goal of this review was to apply normalization principles to the proposed AirBnB schema and ensure that the database design adheres to the **Third Normal Form ($\text{3NF}$)**.

## 1. Summary of Normalization Steps

The current database design is already highly normalized and **no structural changes were required to achieve $\text{3NF}$**.

### Normal Forms Compliance:

| Normal Form | Requirement | Status | Explanation |
| :--- | :--- | :--- | :--- |
| **1NF** | Atomic values, no repeating groups. | **PASSED** | All attributes are single-valued (e.g., `first_name`, `email`), and the schema uses no repeating groups. |
| **2NF** | No partial dependencies (non-key attributes depend on only part of a composite key). | **PASSED** | All entities use a **single-column Primary Key** (a UUID), which automatically satisfies the $\text{2NF}$ requirement since partial dependencies are impossible. |
| **3NF** | No transitive dependencies (non-key attributes depend on other non-key attributes). | **PASSED** | All non-key attributes are directly dependent only on the Primary Key. Foreign Keys are used appropriately to link entities without storing redundant descriptive data. |

---

## 2. $\text{3NF}$ Verification (Transitive Dependencies)

A **transitive dependency** occurs when a non-key attribute determines the value of another non-key attribute (e.g., $\text{PK} \to \text{A} \to \text{B}$, where $\text{A}$ and $\text{B}$ are non-key).

The review confirmed that no such dependencies exist:

* **User Table:** Attributes like `first_name`, `last_name`, and `password_hash` only rely on the $\text{PK}$ (`user_id`).
* **Property Table:** Attributes like `name` and `description` rely only on `property_id`. The $\text{FK}$ (`host_id`) correctly links back to the $\text{User}$ table instead of storing host details redundantly.
* **Booking Table:** The $\text{status}$ and dates rely only on `booking_id`.

### Note on Derived Attributes (`Booking.total_price`)

The attribute `total_price` in the `Booking` table is technically a derived value (calculated from `start_date`, `end_date`, and `Property.pricepernight`).

* **Decision:** We are keeping `total_price` in the `Booking` table.
* **Justification (Pragmatic $\text{3NF}$):** This is standard practice in transactional systems. It is crucial to store the **fixed, historical price** paid at the time of the booking to ensure data integrity for receipts, audit logs, and accounting, even if the property's `pricepernight` changes later. This minor form of denormalization is intentional and does not violate the functional dependency rule for $\text{3NF}$.

## 3. Conclusion

The current AirBnB database design adheres to the **Third Normal Form ($\text{3NF}$)** and provides a robust, non-redundant foundation for the application.
