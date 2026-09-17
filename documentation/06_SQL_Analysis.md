# 1. Database Setup

## Objective

The objective of this step was to create a dedicated MySQL database for the E-Commerce Business Intelligence project.

A separate database was created to provide a structured environment for storing, managing, validating, and analyzing the e-commerce datasets.

## Database Creation

The following database was created:

- **Database Name:** `ecommerce_bi`

### SQL Commands

```sql
CREATE DATABASE ecommerce_bi;
USE ecommerce_bi;
SELECT DATABASE();


# 2. Table Creation

## Objective

The objective of this step was to create a structured relational database schema for the E-Commerce Business Intelligence project.

The database was designed to store customer, order, product, seller, payment, review, and geographical information in separate but related tables.

## Tables Created

A total of **9 tables** were created:

| # | Table Name | Purpose |
|---|---|---|
| 1 | `customers` | Stores customer information and location details |
| 2 | `orders` | Stores order details, status, and order timestamps |
| 3 | `order_items` | Stores products and sellers associated with each order |
| 4 | `payments` | Stores payment methods, installments, and payment values |
| 5 | `reviews` | Stores customer ratings, comments, and review dates |
| 6 | `products` | Stores product attributes, categories, and dimensions |
| 7 | `sellers` | Stores seller information and location details |
| 8 | `geolocation` | Stores geographic coordinates and location information |
| 9 | `category_translation` | Maps product categories to their English translations |

## Primary Keys

Primary keys were defined to uniquely identify records in the database.

- `customers` → `customer_id`
- `orders` → `order_id`
- `order_items` → `order_id + order_item_id`
- `payments` → `order_id + payment_sequential`
- `reviews` → `review_id`
- `products` → `product_id`
- `sellers` → `seller_id`
- `geolocation` → `geolocation_zip_code_prefix`
- `category_translation` → `product_category_name`

## Foreign-Key Relationships

The following relationships were established between the main business entities:

- `orders.customer_id` → `customers.customer_id`
- `order_items.order_id` → `orders.order_id`
- `payments.order_id` → `orders.order_id`
- `reviews.order_id` → `orders.order_id`

These relationships maintain referential integrity and allow data from multiple tables to be combined during analysis.

## Composite Keys

Composite primary keys were used where a single column was not sufficient to uniquely identify a record.

### Order Items

```text
(order_id, order_item_id)



# 3. Data Import

## Objective

The objective of this step was to import the cleaned e-commerce datasets into their corresponding MySQL tables.

The datasets were cleaned and preprocessed before being imported into the `ecommerce_bi` database.

## Source Files

The following cleaned CSV files were imported:

- `customers_clean.csv`
- `orders_clean.csv`
- `order_items_clean.csv`
- `payments_clean.csv`
- `reviews_clean.csv`
- `products_clean.csv`
- `sellers_clean.csv`
- `geolocation_clean.csv`
- `category_translation_clean.csv`

## Import Method

The cleaned CSV files were imported using MySQL's `LOAD DATA LOCAL INFILE` command.

The general import structure used was:

```sql
LOAD DATA LOCAL INFILE 'file_path'
INTO TABLE table_name
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

## Imported Record Counts

| Table | Records Imported |
|---|---:|
| `customers` | 99,441 |
| `orders` | 99,441 |
| `order_items` | 112,650 |
| `payments` | 103,886 |
| `reviews` | 98,408 |
| `products` | 32,951 |
| `sellers` | 3,095 |
| `geolocation` | 738,332 |
| `category_translation` | 71 |
| **Total** | **1,074,527** |

## Import Validation

After importing the datasets, row counts were checked for all 9 tables to confirm that the data was successfully loaded.

All required tables contained imported records and were available for further SQL analysis.

## Review Data Validation

The `reviews` table was additionally validated using:

- **Total Records:** 98,408
- **Unique Review IDs:** 98,408
- **NULL Review IDs:** 0

The review date range was also checked:

- **First Review Date:** 2016-10-02
- **Last Review Date:** 2018-08-31

A difference was observed between the previously expected review record count and the number imported into MySQL. Since the imported review IDs were unique and non-null and no import warnings were generated, this difference was documented as a data reconciliation point rather than an import failure.

## Outcome

All 9 cleaned datasets were successfully imported into the `ecommerce_bi` database.

A total of **1,074,527 records** were loaded across the 9 tables, providing the required data foundation for SQL-based data exploration, validation, and business analysis.

# 4. Data Exploration

## Objective

The objective of the Data Exploration phase was to understand the size, structure, categorical dimensions, date range, missing values, and numerical characteristics of the e-commerce datasets before performing detailed business analysis.

---

## 4.1 Row Count Exploration

### Objective

Calculated the total number of records available in each database table.

### Results

| Table | Row Count |
|---|---:|
| `customers` | 99,441 |
| `orders` | 99,441 |
| `order_items` | 112,650 |
| `payments` | 103,886 |
| `reviews` | 98,408 |
| `products` | 32,951 |
| `sellers` | 3,095 |
| `geolocation` | 738,332 |
| `category_translation` | 71 |
| **Total** | **1,074,527** |

### Key Observations

- `customers` and `orders` contain 99,441 records each.
- `order_items` contains 112,650 records, indicating that an order can contain multiple items.
- `payments` contains 103,886 records, allowing multiple payment records per order.
- `products` contains 32,951 product records.
- `sellers` contains 3,095 seller records.
- `geolocation` is the largest table with 738,332 records.
- `category_translation` contains 71 category mappings.

### Outcome

The row-count analysis established the baseline size and scale of the database for further validation and business analysis.

---

## 4.2 Column Structure Inspection

### Objective

Inspected the structure of all 9 tables using the MySQL `DESCRIBE` command.

### Validation Areas

- Column names
- Data types
- NULL allowance
- Primary keys
- Key relationships
- Default values

### Main Data Types

| Data Type | Usage |
|---|---|
| `VARCHAR` | IDs and categorical fields |
| `INT` | Quantities, scores, and ZIP codes |
| `DECIMAL` | Prices, freight, and monetary values |
| `DATETIME` | Order and review timestamps |
| `TEXT` | Review messages |

### Key Structural Observations

- Customer, order, product, seller, and review IDs are stored as `VARCHAR`.
- Monetary fields such as `price`, `freight_value`, and `payment_value` use `DECIMAL`.
- Order and review timestamps use `DATETIME`.
- Composite primary keys are used in `order_items` and `payments`.

### Outcome

The structure and data types of all 9 tables were successfully inspected and confirmed to be suitable for analytical SQL queries.

---

## 4.3 Categorical Value Exploration

### Objective

Explored important categorical dimensions to understand the distribution of major business entities.

### Dimensions Analyzed

- Order Status
- Payment Type
- Customer State

### Analysis Performed

#### Order Status

Order records were grouped by `order_status` and counted to understand the distribution of orders across different lifecycle stages.

#### Payment Type

Payment records were grouped by `payment_type` to understand the different payment methods used by customers.

#### Customer State

Customers were grouped by `customer_state` to understand the geographic distribution of the customer base.

### Business Relevance

Categorical exploration provides a foundation for:

- Order lifecycle analysis
- Payment behavior analysis
- Geographic segmentation
- Customer analysis
- Power BI filters and slicers

### Outcome

The major categorical dimensions required for future business analysis were identified and explored.

---

## 4.4 Date Range Exploration

### Objective

Determined the overall time period covered by the order dataset.

### Analysis

The minimum and maximum `order_purchase_timestamp` values were analyzed to identify the first and last order dates.

The review dataset was also validated.

### Review Date Range

- **First Review Date:** 2016-10-02
- **Last Review Date:** 2018-08-31

### Business Relevance

Date-range analysis provides the foundation for:

- Monthly sales analysis
- Yearly sales analysis
- Seasonal trend analysis
- Order trend analysis
- Time-based KPI calculations
- Power BI date filtering

### Outcome

The available time period was established for future time-based business analysis.

---

## 4.5 NULL Value Exploration

### Objective

Identified missing values in important business-critical fields.

### Areas Checked

#### Orders

- `order_purchase_timestamp`
- `order_approved_at`
- `order_delivered_customer_date`

#### Products

- `product_category_name`
- `product_weight_g`
- `product_length_cm`

#### Reviews

- `review_score`
- `review_comment_title`
- `review_comment_message`

### Business Relevance

NULL-value analysis is important because missing data can affect:

- KPI calculations
- Aggregations
- Delivery analysis
- Product analysis
- Customer satisfaction analysis
- Dashboard accuracy

### Outcome

Important business-critical fields were examined for missing values and the findings were prepared for detailed Data Quality Validation.

---

## 4.6 Numeric Summary & Review Analysis

### Objective

Performed an initial numerical analysis of product prices, sales value, freight value, and customer review scores.

### Order Item Metrics

The following metrics were analyzed:

- Minimum Product Price
- Maximum Product Price
- Average Product Price
- Total Sales Value
- Total Freight Value

The analysis provides an initial financial overview of the e-commerce dataset.

### Business Relevance

These metrics establish the foundation for:

- Revenue analysis
- Average Order Value
- Product performance analysis
- Freight analysis
- Sales KPI development

### Review Score Analysis

Review scores were grouped and counted to understand the distribution of customer ratings.

This provides a foundation for customer satisfaction analysis and allows review performance to be compared later across:

- Product categories
- Sellers
- Regions
- Orders

### Important Note

The dataset does not contain product cost or COGS information. Therefore, actual profit and profit margin are not calculated from the available dataset.

### Outcome

The initial numerical and review-level analysis established the key metrics required for the upcoming business analysis phases.

---

# Overall Outcome

The Data Exploration phase successfully established the size, structure, and analytical characteristics of the E-Commerce dataset.

### Completed Activities

- Row count analysis
- Column structure inspection
- Categorical value exploration
- Date range analysis
- NULL-value exploration
- Numerical summary
- Review score analysis

### Database Scale

**9 Tables | 1,074,527 Records**

The MySQL database is now ready for the next phase:

**Data Quality Validation → Sales Analysis → Customer Analysis → Product Analysis → Regional Analysis → Payment & Order Analysis → Advanced SQL Analysis → Final KPI Validation**










# 05. Data Quality Validation

## Objective
Validate the quality, integrity, consistency, and reliability of the imported e-commerce data before performing business analysis.

## Validation Checks Performed

### 5.1 Primary Key Validation
Validated primary keys for:
- Customers
- Orders
- Products
- Sellers
- Reviews
- Category Translation

**Result:** All validated primary keys contain **0 NULL values and 0 duplicates**.

### 5.2 Composite Primary Key Validation
Validated composite keys:
- `order_items` → `(order_id, order_item_id)`
- `payments` → `(order_id, payment_sequential)`

**Result:** Both composite keys are unique with **0 NULL values and 0 duplicate keys**.

### 5.3 Foreign Key Validation
Validated relationships between:
- Orders → Customers
- Order Items → Orders
- Payments → Orders
- Reviews → Orders
- Order Items → Products
- Order Items → Sellers

**Result:** **0 orphan records** were identified.

### 5.4 NULL Value Validation
Checked important business and identifier fields across major tables.

**Result:** No NULL values were found in the validated critical fields.

### 5.5 Date Consistency Validation
Checked chronological consistency of order timestamps.

| Validation | Issues |
|---|---:|
| Approved Before Purchase | 160 |
| Delivery Before Purchase | 2,965 |
| Estimated Delivery Before Purchase | 0 |

These records were retained and documented as **data-quality anomalies** rather than being deleted or modified.

### 5.6 Numeric Value Validation
Validated prices, freight values, payment installments, and review scores.

| Validation | Issues |
|---|---:|
| Negative Prices | 0 |
| Negative Freight | 0 |
| Invalid Review Scores | 0 |
| Invalid Payment Installments | 2 |

The 2 payment records contain `payment_installments = 0` and were retained for traceability.

## Final Data Quality Summary

| Table | Total Rows | Unique Keys | NULL Keys |
|---|---:|---:|---:|
| Customers | 99,441 | 99,441 | 0 |
| Orders | 99,441 | 99,441 | 0 |
| Order Items | 112,650 | 112,650 | 0 |
| Payments | 103,886 | 103,886 | 0 |
| Reviews | 98,408 | 98,408 | 0 |
| Products | 32,951 | 32,951 | 0 |
| Sellers | 3,095 | 3,095 | 0 |
| Category Translation | 71 | 71 | 0 |

## Conclusion
The database passed the major structural and integrity validations. Primary keys, composite keys, foreign-key relationships, critical NULL checks, prices, and review scores were validated successfully. A limited number of timestamp and payment-installment anomalies were identified and retained for transparency and further analytical consideration.

**Status: Data Quality Validation Completed**


# 06. Sales Analysis

## Objective
Analyze overall sales performance, revenue trends, order value, order status, and monthly growth using SQL.

## Key Sales KPIs

| KPI | Value |
|---|---:|
| Total Orders | 98,666 |
| Total Items Sold | 112,650 |
| Total Revenue | 13,591,643.70 |
| Total Freight | 225,190.54 |
| Average Item Price | 120.65 |
| Average Order Value (AOV) | 137.75 |

## Analysis Performed

### 6.1 Overall Sales Performance
Calculated total unique orders, items sold, product revenue, freight value, and average item price.

### 6.2 Average Order Value
Calculated AOV using:

`AOV = Total Revenue / Total Orders`

The calculated AOV is **137.75**.

### 6.3 Monthly Sales Trend
Analyzed monthly:
- Orders
- Items Sold
- Revenue
- Freight

The analysis shows a significant increase in sales activity from 2017 onward, with **March 2018** recording the highest monthly revenue in the analyzed results at **983,213.44**.

### 6.4 Yearly Sales Performance

| Year | Orders | Items Sold | Revenue |
|---|---:|---:|---:|
| 2016 | 312 | 370 | 49,785.92 |
| 2017 | 44,579 | 50,864 | 6,155,806.98 |
| 2018 | 53,775 | 61,416 | 7,386,050.80 |

The results show higher order volume and revenue in 2018 compared with 2017.

### 6.5 Order Status Analysis
Sales performance was analyzed across different order statuses, including:
- Delivered
- Shipped
- Canceled
- Unavailable
- Invoiced
- Processing
- Created
- Approved

The **Delivered** status represents the largest share of orders.

### 6.6 Monthly Revenue Growth
Used the SQL `LAG()` window function to compare each month's revenue with the previous month.

**Formula:**

`Growth % = (Current Month Revenue - Previous Month Revenue) / Previous Month Revenue × 100`

This identifies monthly revenue increases and decreases over time.

### 6.7 Top Revenue-Generating Orders
Identified the top 10 individual orders based on product revenue, along with freight and total order value.

The highest-revenue order in the analyzed results generated **13,440.00** in product revenue.

## Business Insights
- Sales activity increased substantially from 2017 onward.
- 2018 recorded the highest annual revenue among the analyzed years.
- Monthly revenue shows fluctuations with both growth and decline periods.
- Delivered orders account for the majority of order volume.
- AOV provides a useful benchmark for understanding average customer order value.

## SQL Concepts Used
- `COUNT()`
- `SUM()`
- `AVG()`
- `DISTINCT`
- `ROUND()`
- `DATE_FORMAT()`
- `YEAR()`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- `JOIN`
- `LEFT JOIN`
- CTE (`WITH`)
- `LAG()` Window Function
- `NULLIF()`

## Conclusion
The Sales Analysis provides a structured view of the e-commerce business's revenue, order volume, sales trends, and order performance. The validated SQL outputs can be used as a foundation for further customer, product, regional, and payment analysis.

**Status: Sales Analysis Completed**




# 07. Customer Analysis

## Objective
Analyze customer base, purchasing behavior, spending patterns, repeat purchases, and customer value segments.

## Key Customer KPIs

| KPI | Value |
|---|---:|
| Total Customer IDs | 99,441 |
| Unique Customers | 96,096 |
| Average Customer IDs per Unique Customer | 1.03 |
| One-Time Customers | 93,099 (96.88%) |
| Repeat Customers | 2,997 (3.12%) |

## Analysis Performed

### 7.1 Customer Overview
Calculated total customer IDs and unique customers using `customer_id` and `customer_unique_id`.

The dataset contains **96,096 unique customers** across **99,441 customer records**.

### 7.2 Top Customers by Revenue
Identified the top 10 customers based on total product revenue and analyzed their order frequency.

The highest-revenue customer in the analyzed results generated **7,388.00** from **2 orders**.

### 7.3 Customer Orders & Spending
Analyzed customer-level:
- Total Orders
- Total Spending
- Average Item Price

This helps identify high-spending and high-frequency customers.

### 7.4 One-Time vs Repeat Customers

| Customer Type | Customers | Percentage |
|---|---:|---:|
| One-Time Customer | 93,099 | 96.88% |
| Repeat Customer | 2,997 | 3.12% |

The analysis shows that the majority of purchasing customers placed only one order.

### 7.5 Customer Revenue Segmentation

| Segment | Customers | Segment Revenue |
|---|---:|---:|
| Low Value | 54,534 | 2,912,659.81 |
| Medium Value | 37,109 | 7,164,169.15 |
| High Value | 3,777 | 3,514,814.74 |

Segments were created using customer-level revenue:
- **Low Value:** Revenue < 100
- **Medium Value:** Revenue 100–499.99
- **High Value:** Revenue ≥ 500

## Business Insights
- The customer base contains **96,096 unique customers**.
- **96.88%** of purchasing customers are one-time customers.
- Repeat customers represent **3.12%** of purchasing customers.
- Medium-value customers contribute the largest segment revenue.
- A relatively smaller high-value customer segment contributes substantial revenue.

## SQL Concepts Used
- `COUNT()`
- `COUNT(DISTINCT)`
- `SUM()`
- `AVG()`
- `ROUND()`
- `JOIN`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- CTE (`WITH`)
- `CASE`
- Window Function `SUM() OVER()`

## Conclusion
Customer Analysis provides a clear view of customer size, spending behavior, repeat purchasing, and revenue contribution across customer segments. These insights can support customer retention, segmentation, and targeted business analysis.

**Status: Customer Analysis Completed**





# 08. Product Analysis

## Objective
Analyze product-level and category-level performance to identify revenue-generating products, sales volume, pricing patterns, and freight contribution.

## Key Product KPIs

| KPI | Value |
|---|---:|
| Products Sold | 32,951 |
| Total Items Sold | 112,650 |
| Total Revenue | 13,591,643.70 |
| Average Product Price | 120.65 |

## Analysis Performed

### 8.1 Product Performance Overview
Calculated the total number of products sold, total items sold, overall revenue, and average product price.

### 8.2 Top Products by Revenue
Identified the top 10 products based on total revenue and analyzed their sales quantity and product category.

### 8.3 Top Products by Quantity Sold
Identified the highest-volume products based on the number of items sold.

This helps distinguish products with high sales volume from products generating high revenue.

### 8.4 Category Performance
Analyzed product categories using:
- Items Sold
- Total Orders
- Total Revenue
- Average Product Price

Top revenue-generating categories included:

| Category | Revenue |
|---|---:|
| beleza_saude | 1,258,681.34 |
| relogios_presentes | 1,205,005.68 |
| cama_mesa_banho | 1,036,988.68 |
| esporte_lazer | 988,048.97 |
| informatica_acessorios | 911,954.32 |

### 8.5 Category Translation Analysis
Used the category translation table to analyze product categories using English category names, improving readability for business reporting and Power BI dashboards.

Examples:
- `beleza_saude` → `health_beauty`
- `relogios_presentes` → `watches_gifts`
- `cama_mesa_banho` → `bed_bath_table`
- `esporte_lazer` → `sports_leisure`
- `informatica_acessorios` → `computers_accessories`

### 8.6 Product Freight Analysis
Identified products with the highest total freight contribution and calculated average freight per item.

This helps understand products that contribute more to shipping costs.

## Business Insights
- The dataset contains **32,951 products** represented in order-item transactions.
- **112,650 items** were sold across the analyzed orders.
- Product revenue totals **13,591,643.70**.
- `beleza_saude` is the highest-revenue category in the analyzed results.
- High-volume products and high-revenue products are not necessarily the same, highlighting the importance of analyzing both quantity and revenue.
- Category translation improves business readability and supports clearer dashboard reporting.

## SQL Concepts Used
- `COUNT()`
- `COUNT(DISTINCT)`
- `SUM()`
- `AVG()`
- `ROUND()`
- `JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- `COALESCE()`

## Note
The dataset does not contain product cost/COGS information. Therefore, profit and profit-margin analysis were not performed.

## Conclusion
Product Analysis provides a detailed view of product and category performance, helping identify high-revenue products, high-volume products, leading categories, and freight-heavy products. These results can be used directly for product performance dashboards and further regional and customer analysis.

**Status: Product Analysis Completed**


# 09. Regional Analysis

## Objective
Analyze geographical sales performance by state, including customer distribution, order volume, revenue, seller presence, and revenue per customer.

## Key Regional Findings

### 9.1 Customer Distribution by State
The highest customer concentrations were observed in:

| State | Unique Customers |
|---|---:|
| SP | 40,302 |
| RJ | 12,384 |
| MG | 11,259 |
| RS | 5,277 |
| PR | 4,882 |

### 9.2 Sales & Revenue by State

| State | Orders | Items Sold | Revenue |
|---|---:|---:|---:|
| SP | 41,375 | 47,449 | 5,202,955.05 |
| RJ | 12,762 | 14,579 | 1,824,092.67 |
| MG | 11,544 | 13,129 | 1,585,308.03 |
| RS | 5,432 | 6,235 | 750,304.02 |
| PR | 4,998 | 5,740 | 683,083.76 |

São Paulo (SP) recorded the highest customer count, order volume, items sold, and total revenue.

### 9.3 Seller Distribution by State
The largest seller concentration was observed in:

| State | Sellers |
|---|---:|
| SP | 1,849 |
| PR | 349 |
| MG | 244 |
| SC | 190 |
| RJ | 171 |

### 9.4 Revenue per Customer
Revenue per customer was calculated to compare customer-level revenue contribution across states.

Highest values in the analyzed results included:

| State | Revenue per Customer |
|---|---:|
| AL | 201.29 |
| AP | 201.11 |
| RO | 196.34 |
| PA | 189.56 |
| TO | 182.43 |

This metric provides a different perspective from total revenue because smaller states can have higher revenue per customer despite having fewer customers.

### 9.5 Top 10 States by Revenue
The top revenue-generating states were:

| State | Orders | Revenue |
|---|---:|---:|
| SP | 41,375 | 5,202,955.05 |
| RJ | 12,762 | 1,824,092.67 |
| MG | 11,544 | 1,585,308.03 |
| RS | 5,432 | 750,304.02 |
| PR | 4,998 | 683,083.76 |
| SC | 3,612 | 520,553.34 |
| BA | 3,358 | 511,349.99 |
| DF | 2,125 | 302,603.94 |
| GO | 2,007 | 294,591.95 |
| ES | 2,025 | 275,037.31 |

## Business Insights
- SP has the largest customer base and sales volume.
- SP also has the highest seller concentration.
- Total revenue is strongly concentrated in the major customer markets.
- Revenue per customer highlights regional differences that are not visible from total revenue alone.
- Combining customer, seller, order, and revenue metrics provides a comprehensive view of regional performance.

## SQL Concepts Used
- `COUNT()`
- `COUNT(DISTINCT)`
- `SUM()`
- `ROUND()`
- `JOIN`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`

## Conclusion
Regional Analysis identifies geographical patterns in customers, sellers, orders, and revenue. The results can be used to build state-level maps, regional KPI cards, and sales-performance visualizations in Power BI.

**Status: Regional Analysis Completed**


# 10. Payment & Order Analysis

## Objective
Analyze payment methods, payment value, installment behavior, and the relationship between payment activity and order status.

## Payment Method Distribution

| Payment Type | Payment Count | Percentage |
|---|---:|---:|
| Credit Card | 76,795 | 73.92% |
| Boleto | 19,784 | 19.04% |
| Voucher | 5,775 | 5.56% |
| Debit Card | 1,529 | 1.47% |
| Not Defined | 3 | 0.00% |

## Payment Value by Method

| Payment Type | Total Payment Value | Average Payment Value |
|---|---:|---:|
| Credit Card | 12,542,084.19 | 163.34 |
| Boleto | 2,869,361.27 | 145.03 |
| Voucher | 379,436.87 | 65.70 |
| Debit Card | 217,989.79 | 142.57 |
| Not Defined | 0.00 | 0.00 |

## Analysis Performed

### 10.1 Payment Method Distribution
Analyzed the frequency and percentage contribution of each payment method.

Credit card is the most frequently used payment method, representing **73.92%** of payment records.

### 10.2 Revenue / Payment Value by Method
Calculated total and average recorded payment value for each payment method.

Credit card payments generated the highest recorded payment value among the available payment methods.

### 10.3 Installment Analysis
Analyzed credit-card payment installments to understand customer payment behavior.

Most installment activity is concentrated in the lower installment ranges, particularly **1–5 installments**.

Two records contain `payment_installments = 0`, which were previously identified during data-quality validation and retained as data anomalies.

### 10.4 Order Status & Payment Value
Compared payment value across order statuses.

Delivered orders account for the largest payment value because they represent the majority of orders.

### 10.5 Highest-Value Orders by Payment
Identified the top orders based on total recorded payment value and examined their payment records and maximum installment count.

## Business Insights
- Credit card is the dominant payment method at **73.92%** of payment records.
- Credit card also contributes the highest recorded payment value.
- Boleto is the second most frequently used payment method.
- Most credit-card installment activity occurs within the lower installment ranges.
- Delivered orders represent the largest share of recorded payment value.
- A small number of payment-data anomalies were identified and retained for transparency.

## SQL Concepts Used
- `COUNT()`
- `COUNT(DISTINCT)`
- `SUM()`
- `AVG()`
- `ROUND()`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- `JOIN`
- `CASE`
- CTE / Window Functions

## Important Note
`payment_value` represents recorded payment amounts and is analyzed separately from the project's sales revenue, which is calculated from `order_items.price`.

## Conclusion
Payment & Order Analysis provides visibility into customer payment preferences, payment values, installment behavior, and order-status payment patterns. These results can support payment-method analysis and transaction-related visualizations in Power BI.

**Status: Payment & Order Analysis Completed**

# 11. Advanced SQL Analysis

## Objective
Apply advanced SQL techniques to perform customer segmentation, product ranking, cumulative revenue analysis, and category contribution analysis.

## Analysis Performed

### 11.1 Customer Lifetime Value (CLV)
Calculated customer-level lifetime value using total product revenue generated across all orders.

Key metrics:
- Total Orders per Customer
- Lifetime Revenue

The highest-value customer in the analyzed results generated **13,440.00** from a single order.

### 11.2 RFM Analysis
Performed RFM-based customer segmentation using:

- **Recency** — Days since the customer's most recent purchase
- **Frequency** — Number of orders placed
- **Monetary** — Total revenue generated

Customer segments were created using business rules:

| Segment | Criteria |
|---|---|
| High Value | Recency ≤ 90, Frequency ≥ 2, Monetary ≥ 500 |
| Loyal | Recency ≤ 180, Frequency ≥ 2 |
| At Risk | Recency > 365 |
| Regular | Remaining customers |

This provides a structured approach for identifying valuable, loyal, regular, and potentially inactive customers.

### 11.3 Product Revenue Ranking
Ranked products according to total revenue using the `DENSE_RANK()` window function.

The highest-ranked product generated **63,885.00** in revenue.

### 11.4 Monthly Running Revenue
Calculated cumulative revenue over time using a SQL window function.

The final cumulative revenue reached:

**13,591,643.70**

This matches the overall revenue calculated in Sales Analysis, providing a cross-check of the SQL calculations.

### 11.5 Category Revenue Contribution
Calculated each product category's percentage contribution to total revenue.

Top categories included:

| Category | Revenue | Contribution |
|---|---:|---:|
| beleza_saude | 1,258,681.34 | 9.26% |
| relogios_presentes | 1,205,005.68 | 8.87% |
| cama_mesa_banho | 1,036,988.68 | 7.63% |
| esporte_lazer | 988,048.97 | 7.27% |
| informatica_acessorios | 911,954.32 | 6.71% |

## Business Insights
- Customer lifetime value identifies the highest-revenue customers.
- RFM analysis provides a framework for customer segmentation based on purchasing behavior.
- Product ranking identifies high-revenue products.
- Running revenue provides a cumulative view of business performance over time.
- Category contribution highlights the categories with the largest share of total revenue.

## Advanced SQL Concepts Used
- Common Table Expressions (`WITH`)
- `CASE`
- `DATEDIFF()`
- `DENSE_RANK()`
- `LAG()`
- `SUM() OVER()`
- `COUNT(DISTINCT)`
- `GROUP BY`
- `ORDER BY`
- `ROUND()`

## Note
RFM segments are analytical classifications created using project-specific business rules. They are not predefined categories in the original dataset.

## Conclusion
Advanced SQL Analysis demonstrates the use of SQL for deeper business analytics beyond basic aggregation. The analysis supports customer segmentation, product prioritization, revenue tracking, and category-level performance analysis.

**Status: Advanced SQL Analysis Completed**


# 12. Final KPI Validation

## Objective
Perform final validation of the key business metrics generated throughout the SQL analysis and ensure consistency before moving to Power BI dashboard development.

## Final Validated KPIs

| KPI | Final Value |
|---|---:|
| Total Orders in Orders Table | 99,441 |
| Orders with Sales Items | 98,666 |
| Total Items Sold | 112,650 |
| Total Revenue | 13,591,643.70 |
| Unique Customers | 96,096 |
| Total Products | 32,951 |
| Total Freight | 225,190.54 |
| Average Order Value (AOV) | 137.75 |

## KPI Cross-Validation

The major KPIs were cross-checked against previous SQL analysis:

- Total Revenue = **13,591,643.70**
- Running Revenue final value = **13,591,643.70**
- Total Items Sold = **112,650**
- Unique Customers = **96,096**
- Total Products = **32,951**
- Total Freight = **225,190.54**
- AOV = **137.75**

The revenue calculated in Advanced SQL running-total analysis matches the overall Sales Analysis revenue, confirming consistency.

## Order Count Reconciliation

A difference was identified between the total records in the `orders` table and orders represented in `order_items`:

| Metric | Count |
|---|---:|
| Orders Table Records | 99,441 |
| Orders with Order Items | 98,666 |
| Difference | 775 |

The **775-order difference** indicates orders that do not have corresponding records in `order_items`.

Therefore:
- **99,441** represents the complete order-table population.
- **98,666** represents orders available for item-level sales analysis.

Sales and revenue calculations should use the relevant `order_items` records to maintain consistency with revenue calculations.

## Data Quality Context

Previously identified data-quality anomalies were retained rather than deleted:

- Invalid payment installments: **2**
- Approved before purchase: **160**
- Delivery before purchase: **2,965**

These records remain part of the source data and are documented for transparency.

## SQL Project Final KPI Set

The following metrics are ready to be used as the foundation for Power BI:

- Total Orders
- Total Items Sold
- Total Revenue
- Total Customers
- Total Products
- Total Freight
- Average Order Value
- Monthly Revenue
- Yearly Revenue
- Customer Segments
- Product & Category Performance
- Regional Revenue
- Payment Method Performance

## Conclusion
The final KPI validation confirms that the major business metrics are consistent across the SQL analysis workflow. The identified order-count reconciliation and data-quality anomalies have been documented without altering the source records.

The SQL analysis phase is now complete and the validated metrics are ready for **Power BI Data Modeling and Dashboard Development**.

**Status: Final KPI Validation Completed**

**Overall SQL Phase: COMPLETED**
