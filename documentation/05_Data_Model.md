# 03 — Data Model Validation & Relationship Analysis

## 1. Overview

This document describes the data model validation performed on the cleaned e-commerce datasets.

The objective of this phase was to verify:

- Dataset structure and table grain
- Primary keys
- Composite keys
- Foreign keys
- Referential integrity
- Table relationships
- Category translation mapping
- Unmatched category impact

The validation ensures that the cleaned datasets can be safely used for downstream SQL analysis, Python EDA, and Power BI data modeling.

---

# 2. Datasets Used

The following cleaned datasets from `Data/processed/` were used:

| Dataset | Rows | Columns |
|---|---:|---:|
| Customers | 99,441 | 5 |
| Orders | 99,441 | 8 |
| Order Items | 112,650 | 7 |
| Payments | 103,886 | 5 |
| Reviews | 99,224 | 7 |
| Products | 32,951 | 9 |
| Sellers | 3,095 | 4 |
| Geolocation | 738,332 | 5 |
| Category Translation | 71 | 2 |

---

# 3. Data Grain

Understanding the grain of each table is important before creating relationships.

| Dataset | Grain |
|---|---|
| Customers | One row represents a customer record |
| Orders | One row represents an order |
| Order Items | One row represents one item within an order |
| Payments | One row represents one payment sequence within an order |
| Reviews | One row represents a review associated with an order |
| Products | One row represents a product |
| Sellers | One row represents a seller |
| Geolocation | One row represents a geographical location record |
| Category Translation | One row represents a product-category translation mapping |

The different grains explain why some columns cannot be used as standalone primary keys.

---

# 4. Primary Key Validation

## 4.1 Definition

A primary key is a column, or combination of columns, that uniquely identifies a record within a table.

A valid primary key should generally:

1. Uniquely identify each row
2. Contain no NULL values
3. Have no duplicate values

---

## 4.2 Customers

### Primary Key

```text
customer_id