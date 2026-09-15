# Data Inventory

## 1. Dataset Overview

The project uses the Olist Brazilian E-Commerce Public Dataset.
The dataset contains information about customers, orders, products,
sellers, payments, reviews, and geographical locations.

The data is distributed across multiple CSV files that can be
joined using primary and foreign key relationships.

---

## 2. Available Tables

| Table | Purpose | Approx. Rows |
|---|---|---:|
| Customers | Customer information | 99,441 |
| Orders | Order lifecycle information | 99,441 |
| Order Items | Products purchased in each order | 112,650 |
| Payments | Payment information | 103,886 |
| Reviews | Customer reviews | 99,224 |
| Products | Product attributes | 32,951 |
| Sellers | Seller information | 3,095 |
| Geolocation | ZIP-code geographic information | 1,000,163 |
| Category Translation | Portuguese-English category mapping | 71 |

---

## 3. Table Descriptions

### Customers

Contains customer-level information such as customer ID,
location, city, and state.

### Orders

Contains information about each order, including order status,
purchase timestamp, approval, delivery, and estimated delivery dates.

### Order Items

Contains individual products included within an order,
along with seller, price, freight value, and shipping limit date.

### Payments

Contains payment transactions associated with orders,
including payment type, installments, and payment value.

### Reviews

Contains customer review information including review score,
comments, creation date, and response timestamp.

### Products

Contains product-level attributes including category,
dimensions, weight, description length, and number of photos.

### Sellers

Contains seller identification and geographic information.

### Geolocation

Contains geographic coordinates and location information
associated with ZIP-code prefixes.

### Category Translation

Maps Portuguese product category names to English names.

---

## 4. Important Data Relationships

The major relationships are:

Customers → Orders

Orders → Order Items

Products → Order Items

Sellers → Order Items

Orders → Payments

Orders → Reviews

Products → Category Translation

Geolocation → Customers / Sellers