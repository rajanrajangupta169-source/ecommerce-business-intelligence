# Data Model

## 1. Objective

Create a reliable analytical data model that allows
sales, customer, product, seller, payment, and review
analysis without double-counting metrics.

---

## 2. Core Tables

### Customers

Customer-level information.

### Orders

Order-level information.

### Order Items

Individual products purchased within orders.

### Products

Product-level information.

### Sellers

Seller-level information.

### Payments

Payment transactions associated with orders.

### Reviews

Customer review information.

---

## 3. Key Relationships

Customers
→ Orders

Orders
→ Order Items

Products
→ Order Items

Sellers
→ Order Items

Orders
→ Payments

Orders
→ Reviews

Products
→ Category Translation

---

## 4. Analytical Model

The final Power BI model will use an appropriate
star-schema-oriented design where possible.

Fact tables:

- Fact Orders
- Fact Order Items
- Fact Payments
- Fact Reviews

Dimension tables:

- Dim Customer
- Dim Product
- Dim Seller
- Dim Date
- Dim Geography

---

## 5. Modeling Principles

- Avoid many-to-many relationships where unnecessary
- Maintain a clear table grain
- Avoid duplicate measures caused by joins
- Use dimension tables for filtering and slicing
- Keep transactional facts at their natural grain