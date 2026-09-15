# Data Quality Report

## 1. Objective

Assess the quality, completeness, consistency, and reliability
of the source datasets before analytical processing.

The purpose of this analysis is to identify data quality issues,
understand their potential business impact, and document the
treatment applied to each issue.

---

# 2. Data Quality Methodology

The following checks will be performed for each dataset:

1. Dataset structure and overview
2. Missing value analysis
3. Full-row duplicate analysis
4. Primary key validation
5. Foreign key integrity
6. Data type validation
7. Date validation
8. Numerical value validation
9. Outlier analysis
10. Final treatment and conclusion

No records will be removed without first understanding the
business meaning and documenting the reason.

---

# 3. Dataset-Level Data Quality Analysis

## 3.1 Customers

### Dataset Purpose

The Customers dataset contains customer identification and
geographic information.

### Dataset Overview

- Total Rows: 99,441
- Total Columns: 5

### Grain

One row represents one customer record associated with a
customer order/address context.

The `customer_unique_id` may appear multiple times because
the same underlying customer can be associated with multiple
customer records.

### Columns

- `customer_id` — Customer record identifier
- `customer_unique_id` — Unique customer identifier
- `customer_zip_code_prefix` — Customer ZIP code prefix
- `customer_city` — Customer city
- `customer_state` — Customer state

### Missing Values

No missing values were identified across the five columns.

| Column | Missing Count | Missing Percentage |
|---|---:|---:|
| `customer_id` | 0 | 0.00% |
| `customer_unique_id` | 0 | 0.00% |
| `customer_zip_code_prefix` | 0 | 0.00% |
| `customer_city` | 0 | 0.00% |
| `customer_state` | 0 | 0.00% |

**Decision:** Keep all records. No missing-value treatment is required.

### Duplicate Records

No full-row duplicate records were identified.

**Duplicate Count:** 0

**Decision:** No duplicate records require removal.

### Customer Unique ID Validation

The `customer_unique_id` field was checked for missing values
and repeated occurrences.

No missing values were identified.

The field contains repeated customer IDs, with some customers
appearing multiple times. This is expected because
`customer_unique_id` represents the underlying customer,
whereas `customer_id` identifies the individual customer record.

Therefore, `customer_unique_id` is not treated as the primary key.

**Decision:** Keep repeated `customer_unique_id` values.


### Data Type Validation

The dataset contains:

- `customer_id` → Object/String
- `customer_unique_id` → Object/String
- `customer_zip_code_prefix` → Integer
- `customer_city` → Object/String
- `customer_state` → Object/String

The data types are appropriate for the intended analytical use.

**Decision:** No data type transformation is required at this stage.

### Geographic Validation

The `customer_state` column contains 27 distinct state codes,
and the dataset contains 4,119 distinct cities.

The customer ZIP code prefix ranges from 1,003 to 99,990.

No missing geographic values were identified.

**Decision:** Geographic fields are retained for further analysis.
Additional geographic consistency checks may be performed during
data integration with the Geolocation dataset.

### Final Treatment

No records were removed from the Customers dataset.

The dataset requires no missing-value or duplicate-row treatment.
The `customer_id` field passed the initial primary key validation.

### Conclusion

The Customers dataset is structurally complete and contains
no full-row duplicates or missing values. The `customer_id`
field is unique and non-null across all 99,441 records.

The dataset is suitable for further analytical processing,
subject to the remaining validation checks and relationship
validation with other datasets.

## 3.2 Orders

### Understand

- Rows: 99,441
- Columns: 8
- Grain: One row represents one order.
- `order_id` identifies the order.
- `customer_id` identifies the customer associated with the order.
- `order_status` represents the order lifecycle status.
- The dataset contains purchase, approval, shipping, delivery,
  and estimated delivery timestamps.

### Missing Values

Missing values were found in the following columns:

| Column | Missing Count | Missing % |
|---|---:|---:|
| `order_approved_at` | 160 | 0.16% |
| `order_delivered_carrier_date` | 1,783 | 1.79% |
| `order_delivered_customer_date` | 2,965 | 2.98% |

The missing delivery dates are mainly associated with orders
that have not completed the delivery process, such as canceled,
created, invoiced, processing, shipped, and unavailable orders.

Some `delivered` orders also contain missing lifecycle dates,
which should be investigated.

**Decision:** Missing values will be retained where they are
logically related to the order status. Potential inconsistencies
will be flagged for further investigation.

### Duplicates

- Full-row duplicate records: 0

No exact duplicate rows were found in the Orders dataset.

**Decision:** No records were removed due to duplicate rows.

### Primary Key

**Primary Key:** `order_id`

- Null `order_id`: 0
- Unique `order_id`: 99,441
- Total rows: 99,441

Since the number of unique `order_id` values matches the total
number of records and there are no null values, the primary key
check passes.

**Result:** `order_id` is valid as the primary key.

### Validation

#### Customer ID

- Null `customer_id`: 0
- Unique `customer_id`: 99,441

All Orders records contain a customer ID.

#### Order Status

The dataset contains multiple order lifecycle statuses,
including delivered, canceled, created, invoiced, processing,
shipped, approved, and unavailable.

#### Date Fields

The following date fields are currently stored as `object`:

- `order_purchase_timestamp`
- `order_approved_at`
- `order_delivered_carrier_date`
- `order_delivered_customer_date`
- `order_estimated_delivery_date`

These fields should be converted to `datetime` during the
data-cleaning stage.

The expected order lifecycle is:

`Purchase → Approval → Carrier Handover → Customer Delivery`

Chronological date validation will be performed after
converting the fields to datetime.

### Conclusion

The Orders dataset contains 99,441 records with no full-row
duplicates and a valid `order_id` primary key.

Missing values are present mainly in order lifecycle dates.
Most are explainable by the order status, while a small number
of delivered orders require further investigation.

The next step is datetime conversion and chronological
validation of the order lifecycle.

---

## 3.3 Order Items Dataset

### Dataset Overview

The Order Items dataset contains item-level information for each
order, including products, sellers, prices, freight charges, and
shipping limit dates.

- Rows: 112,650
- Columns: 7

Columns:

- `order_id`
- `order_item_id`
- `product_id`
- `seller_id`
- `shipping_limit_date`
- `price`
- `freight_value`

---

###  Missing Values

All 7 columns contain no missing values.

| Column | Missing Count | Missing % |
|---|---:|---:|
| order_id | 0 | 0.00% |
| order_item_id | 0 | 0.00% |
| product_id | 0 | 0.00% |
| seller_id | 0 | 0.00% |
| shipping_limit_date | 0 | 0.00% |
| price | 0 | 0.00% |
| freight_value | 0 | 0.00% |

**Decision:** No missing-value treatment is required.

---

###  Duplicate Records

Full-row duplicate validation was performed.

- Duplicate rows: 0

**Decision:** No duplicate records were identified.

---

###  Primary Key Validation

`order_item_id` alone is not unique because one order can contain
multiple items.

Therefore, the logical composite key is:

`order_id + order_item_id`

Validation result:

- Missing `order_id`: 0
- Unique `order_id`: 98,666
- Duplicate `order_id + order_item_id`: 0

**Decision:** The composite key `order_id + order_item_id` is valid
and uniquely identifies each order item record.

---

###  Data Type Validation

The dataset contains:

- `order_id`: Object/String
- `order_item_id`: Integer
- `product_id`: Object/String
- `seller_id`: Object/String
- `shipping_limit_date`: Object
- `price`: Float
- `freight_value`: Float

The ID columns are appropriately stored as string/object values,
while price and freight values are numeric.

`shipping_limit_date` is currently stored as object and should be
converted to DateTime during the data-cleaning stage.

---

###  Numerical Validation

Price statistics:

- Minimum price: 0.85
- Median price: 74.90
- Mean price: 120.65

Freight value statistics:

- Minimum freight value: 0.00
- Median freight value: 16.26
- Mean freight value: 19.99
- Maximum freight value: 409.68

No missing values were identified in the numerical columns.

**Decision:** Price and freight values are suitable for further
analysis. Outlier analysis will be performed during the EDA stage.

---

###  Order Item Distribution

The `order_item_id` column shows that most orders contain one item,
while a smaller number of orders contain multiple items.

The highest frequency is:

- `order_item_id = 1`: 98,666 records
- `order_item_id = 2`: 9,803 records
- `order_item_id = 3`: 2,287 records

This indicates that most orders contain a single item, while
multi-item orders represent a smaller portion of the dataset.

---

###  Data Quality Conclusion

The Order Items dataset is generally of good quality.

Key findings:

- No missing values
- No full-row duplicates
- Composite primary key validated
- ID fields are complete
- Price and freight fields are numeric
- Shipping date requires DateTime conversion
- Potential numerical outliers should be investigated during EDA

**Overall Status:** Suitable for analytical processing after
standard date-type conversion and further business-level validation.


---

## 3.4 Payments

###  Dataset Overview

The Payments dataset contains payment-level information associated
with customer orders. It includes payment method, installment
details, and payment value.

- Rows: 103,886
- Columns: 5

Columns:

- `order_id`
- `payment_sequential`
- `payment_type`
- `payment_installments`
- `payment_value`

---

###  Missing Values

No missing values were identified in any column.

| Column | Missing Count | Missing % |
|---|---:|---:|
| order_id | 0 | 0.00% |
| payment_sequential | 0 | 0.00% |
| payment_type | 0 | 0.00% |
| payment_installments | 0 | 0.00% |
| payment_value | 0 | 0.00% |

**Decision:** No missing-value treatment is required.

---

###  Duplicate Records

Full-row duplicate validation was performed.

- Duplicate rows: 0

**Decision:** No duplicate records were identified.

---

###  Primary Key Validation

`order_id` is not a unique identifier in the Payments dataset
because a single order can contain multiple payment records.

Validation result:

- Missing `order_id`: 0
- Unique `order_id`: 99,440
- Total payment records: 103,886

Therefore, `order_id` should be treated as a foreign key/reference
to the Orders dataset rather than as the primary key of this table.

`payment_sequential` represents the sequence of payments within
an order.

**Logical Key:** `order_id + payment_sequential`

This composite key should be used to uniquely identify individual
payment records.

---

###  Data Type Validation

The current data types are:

- `order_id`: Object/String
- `payment_sequential`: Integer
- `payment_type`: Object/String
- `payment_installments`: Integer
- `payment_value`: Float

The data types are appropriate for analytical processing.

---

###  Payment Type Validation

The payment methods identified are:

| Payment Type | Records |
|---|---:|
| credit_card | 76,795 |
| boleto | 19,784 |
| voucher | 5,775 |
| debit_card | 1,529 |
| not_defined | 3 |

Credit card is the dominant payment method, followed by boleto.

The `not_defined` category contains only 3 records and should be
flagged for investigation during the cleaning stage.

---

### Payment Value Validation

Payment value statistics:

- Mean: 154.10
- Median: 100.00
- Minimum: 0.00
- Maximum: 13,664.08

Validation results:

- Negative payment values: 0
- Zero payment values: 9

No negative payment values were identified.

The zero-value payment records should be investigated to determine
whether they represent valid business transactions or data anomalies.

The maximum payment value is substantially higher than the median,
so high-value transactions should be reviewed during outlier
analysis.

---

###  Payment Installment Validation

Installment statistics:

- Mean: 2.85
- Median: 1
- Minimum: 0
- Maximum: 24

Validation result:

- Invalid installments (`<= 0`): 2

Two records contain zero installments and should be investigated
during data cleaning.

Most payment records use a small number of installments, with
single-payment transactions being the most common.

---

###  Data Quality Conclusion

The Payments dataset is generally of good quality.

Key findings:

- No missing values
- No full-row duplicates
- `order_id` is complete
- `order_id` is not unique and should not be treated as the primary key
- `order_id + payment_sequential` is the logical composite key
- Payment values contain no negative values
- 9 zero-value payments require investigation
- 2 records have invalid zero installments
- 3 records have `not_defined` payment type
- High payment values should be reviewed during outlier analysis

**Overall Status:** Suitable for analytical processing after
investigating zero-value payments, invalid installments, and
`not_defined` payment types.


---

## 3.5 Reviews


###  Dataset Overview

The Reviews dataset contains **99,224 records** and **7 columns**.

The dataset stores customer review information associated with orders, including review scores, review comments, review creation dates, and review response timestamps.

###  Missing Values

Missing-value analysis identified missing records in two columns:

- `review_comment_title`: **87,656 missing values (88.34%)**
- `review_comment_message`: **58,247 missing values (58.70%)**

The remaining columns have **0% missing values**.

The missing values in review title and review message are expected because customers are not required to provide written comments with their reviews.

###  Duplicates

Full-row duplicate check returned:

- **Duplicate rows: 0**

Therefore, no exact duplicate records were identified in the Reviews dataset.

###  Primary Key Check

The `review_id` column was evaluated as the primary identifier.

Results:

- Missing `review_id`: **0**
- Total records: **99,224**
- Unique `review_id`: **98,410**

Since the number of unique `review_id` values is lower than the total number of records, `review_id` is **not completely unique** in the dataset.

This should be considered during data modeling and downstream analysis.

###  Validation

#### Data Types

The dataset contains:

- `review_id` → object
- `order_id` → object
- `review_score` → int64
- `review_comment_title` → object
- `review_comment_message` → object
- `review_creation_date` → object
- `review_answer_timestamp` → object

The `review_score` column uses an integer data type, while the remaining fields are stored as object/string types.

#### Review Score Validation

The review score distribution is:

| Review Score | Record Count |
|---:|---:|
| 1 | 11,424 |
| 2 | 3,151 |
| 3 | 8,179 |
| 4 | 19,142 |
| 5 | 57,328 |

The validation check identified:

- Invalid review scores: **0**

Therefore, all review scores fall within the expected **1–5 range**.

#### Missing Review Fields by Score

Missing review comments were observed across all review-score categories. The highest number of missing values occurs among **5-star reviews**, which is expected because many customers provide a rating without writing a comment.

###  Data Quality Summary

Overall, the Reviews dataset is structurally reliable with **no full-row duplicates**, **no missing review IDs**, and **no invalid review scores**.

The main data-quality issue is the high percentage of missing textual review fields, particularly `review_comment_title` (88.34%) and `review_comment_message` (58.70%). These fields should not automatically be treated as errors because written comments are optional.

Additionally, `review_id` contains fewer unique values than the total number of records, so it should **not be treated as a strictly unique primary key without further investigation**.


---

## 3.6 Products

### Dataset Overview
- Total Rows: 32,951
- Total Columns: 9
- Duplicate Rows: 0
- Primary Key: `product_id`
- Unique Product IDs: 32,951
- Missing Product IDs: 0
- Primary Key Status: PASS

### Columns
1. `product_id`
2. `product_category_name`
3. `product_name_lenght`
4. `product_description_lenght`
5. `product_photos_qty`
6. `product_weight_g`
7. `product_length_cm`
8. `product_height_cm`
9. `product_width_cm`

### Data Types
- `product_id` → object
- `product_category_name` → object
- `product_name_lenght` → float64
- `product_description_lenght` → float64
- `product_photos_qty` → float64
- `product_weight_g` → float64
- `product_length_cm` → float64
- `product_height_cm` → float64
- `product_width_cm` → float64

### Missing Value Analysis
- `product_category_name`: 610 missing values (1.85%)
- `product_name_lenght`: 610 missing values (1.85%)
- `product_description_lenght`: 610 missing values (1.85%)
- `product_photos_qty`: 610 missing values (1.85%)
- `product_weight_g`: 2 missing values (0.01%)
- `product_length_cm`: 2 missing values (0.01%)
- `product_height_cm`: 2 missing values (0.01%)
- `product_width_cm`: 2 missing values (0.01%)
- `product_id`: No missing values

### Duplicate Analysis
- Duplicate rows: 0
- Duplicate `product_id`: 0
- All product IDs are unique.

### Product Category Validation
The dataset contains multiple product categories, with the highest represented categories including:
- Bed, Table & Bath: 3,029
- Sports & Leisure: 2,867
- Furniture & Decoration: 2,657
- Beauty & Health: 2,444
- Housewares: 2,335

### Numeric Validation

#### Product Name Length
- Minimum: 5
- Maximum: 76
- Mean: 48.48

#### Product Description Length
- Minimum: 4
- Maximum: 3,992
- Mean: 771.50

#### Product Photos Quantity
- Minimum: 1
- Maximum: 20
- Zero photos: 0

#### Product Weight
- Minimum: 0 g
- Maximum: 40,425 g
- Mean: 2,276.47 g
- Negative values: 0
- Zero values: 4

#### Product Dimensions
- Product Length: 7–105 cm
- Product Height: 2–105 cm
- Product Width: 6–118 cm
- Negative dimension values: 0
- Zero dimension values: 0

### Data Quality Findings
- No duplicate records were found.
- `product_id` is complete and uniquely identifies every product.
- No negative product weights or dimensions were found.
- Product photo quantity is valid, with every product having at least one photo.
- A small number of products have zero recorded weight.
- Most missing values are concentrated in product category and text/photo-related fields.
- Overall product data is structurally consistent and suitable for further analysis after appropriate missing-value handling.

### Final Status
**Products Data Quality Check: PASS**

The Products dataset has a valid primary key, no duplicate records, no invalid negative measurements, and only a small percentage of missing values.


---

## 3.7 Sellers

# 07. -------------------------------------------------------------- SELLERS

# Dataset Overview
print("Rows:", len(sellers))
print("Columns:", len(sellers.columns))


# Preview
display(sellers.head())


# Info
sellers.info()


#  Missing Values
print("\n--- Missing Values ---")
print(sellers.isna().sum())


#  Missing Values Percentage
print("\n--- Missing Values Percentage ---")
print((sellers.isna().sum() / len(sellers) * 100).round(2))


#  Duplicate Rows
print("\n--- Duplicate Rows ---")
print("Duplicate rows:", sellers.duplicated().sum())


#  Primary Key Check
print("\n--- Primary Key Check ---")

print("Missing seller_id:",
      sellers["seller_id"].isna().sum())

print("Duplicate seller_id:",
      sellers["seller_id"].duplicated().sum())

print("Unique seller_id:",
      sellers["seller_id"].nunique())

print("Total rows:",
      len(sellers))


#  Column Names
print("\n--- Column Names ---")
print(sellers.columns.tolist())


#  Data Types
print("\n--- Data Types ---")
print(sellers.dtypes)


#  Seller State Distribution
print("\n--- Seller State Distribution ---")
print(sellers["seller_state"].value_counts())


#  Seller City Distribution
print("\n--- Top 15 Seller Cities ---")
print(sellers["seller_city"].value_counts().head(15))


#  ZIP Code Validation
print("\n--- ZIP Code Validation ---")

print("Minimum zip code prefix:",
      sellers["seller_zip_code_prefix"].min())

print("Maximum zip code prefix:",
      sellers["seller_zip_code_prefix"].max())

print("Zero zip code:",
      (sellers["seller_zip_code_prefix"] == 0).sum())

print("Negative zip code:",
      (sellers["seller_zip_code_prefix"] < 0).sum())


#  Unique Values
print("\n--- Unique Values ---")

print("Unique seller cities:",
      sellers["seller_city"].nunique())

print("Unique seller states:",
      sellers["seller_state"].nunique())

print("Unique zip code prefixes:",
      sellers["seller_zip_code_prefix"].nunique())


#  Final Validation
print("\n========== FINAL STATUS ==========")

if (
    sellers["seller_id"].isna().sum() == 0
    and sellers["seller_id"].duplicated().sum() == 0
    and sellers.duplicated().sum() == 0
    and sellers["seller_zip_code_prefix"].isna().sum() == 0
    and (sellers["seller_zip_code_prefix"] < 0).sum() == 0
    and (sellers["seller_zip_code_prefix"] == 0).sum() == 0
):
    print("Seller ID / Duplicate / ZIP Code Check: PASS")
else:
    print("Seller Data Quality Check: REVIEW")


---

## 3.8 Geolocation

GEOLOCATION VALIDATION

--- Dataset Overview ---
Rows: 1,000,163
Columns: 5

--- Column Names ---
['geolocation_zip_code_prefix',
 'geolocation_lat',
 'geolocation_lng',
 'geolocation_city',
 'geolocation_state']

--- Data Types ---
geolocation_zip_code_prefix      int64
geolocation_lat                float64
geolocation_lng                float64
geolocation_city                object
geolocation_state               object

--- Missing Values ---
geolocation_zip_code_prefix    0
geolocation_lat                 0
geolocation_lng                 0
geolocation_city                0
geolocation_state               0

--- Duplicate Rows ---
Duplicate rows: 261,831

Note:
Duplicate geolocation records are present because multiple records
can share the same ZIP code/location information. These duplicates
are not treated as a primary-key failure.

--- Geographic Validation ---
Invalid Latitude: 0
Invalid Longitude: 0
Negative ZIP Code: 0

Latitude valid range: -90 to 90
Longitude valid range: -180 to 180

--- ZIP Code Validation ---
Total ZIP records: 1,000,163
Unique ZIP Code Prefixes: 19,015

--- Primary Key / Uniqueness ---
Geolocation ZIP code prefix is NOT treated as a primary key because
multiple geographic records can belong to the same ZIP code prefix.

--- FINAL STATUS ---
Missing Value Check: PASS
Latitude Validation: PASS
Longitude Validation: PASS
ZIP Code Validation: PASS
Geographic Data Quality: PASS
Duplicate Check: REVIEW (expected/referential duplicates)


---

## 3.9 Category Translation

09. CATEGORY TRANSLATION — DATA QUALITY DOCUMENTATION

--- Dataset Overview ---
Rows: 71
Columns: 2

--- Columns ---
product_category_name
product_category_name_english

--- Important Validation ---
Missing Values: 0
Duplicate Rows: 0
Portuguese Categories: 71
English Categories: 71
Empty Category Values: 0

--- Data Quality Assessment ---
- All category translation records are complete.
- No duplicate mappings were found.
- All Portuguese categories have corresponding English translations.
- Column data types are appropriate for category mapping.

--- FINAL STATUS ---
Category Translation Data Quality: PASS


---

# 4. Overall Data Quality Summary


## Major Findings

| Dataset | Issue | Severity | Business Impact | Treatment |
|---|---|---|---|---|
| Customers | No missing values or duplicate rows identified | Low | Reliable customer-level analysis | Keep |
| Orders | 4,908 missing values | Medium | May affect order-level analysis and joins | Investigate and handle appropriately |
| Order Items | No major missing or duplicate records identified | Low | Reliable order-item analysis | Keep |
| Payments | No missing or duplicate records identified | Low | Reliable payment analysis | Keep |
| Reviews | 145,903 missing values | High | May affect review, rating and customer feedback analysis | Handle missing values based on business context |
| Products | 2,448 missing values | Medium | May affect product attributes and product-level analysis | Handle missing values appropriately |
| Sellers | No missing or duplicate records identified | Low | Reliable seller-level analysis | Keep |
| Geolocation | 261,831 duplicate rows | Medium | May affect geographic aggregation and location-based analysis | Validate and handle duplicates carefully |
| Category Translation | No missing or duplicate records identified | Low | Reliable category mapping | Keep |

---

#  Data Cleaning Strategy

Data cleaning decisions will be based on the results of the data quality validation and the business context.

The following treatment strategy will be applied:

- **Keep:** Valid records with no quality issues will be retained.
- **Replace:** Missing values will be replaced only when a meaningful business-based value is available.
- **Transform:** Data types, formats and values will be transformed where required.
- **Remove:** Records will be removed only when they are confirmed to be invalid or unusable.
- **Flag for Investigation:** Suspicious values, extreme values and potential duplicate records will be reviewed before making changes.

### Dataset-Specific Cleaning Approach

- **Orders:** Investigate missing values and determine whether they affect important analytical fields.
- **Reviews:** Analyze the reason for missing values and retain records where other review information remains useful.
- **Products:** Handle missing product attributes carefully without affecting valid product records.
- **Geolocation:** Validate duplicate geographic records before removing anything, as multiple records may represent repeated ZIP-code/location observations.
- **Other Datasets:** Keep valid records where no significant quality issue was identified.

**No records will be removed without documenting the reason and business justification.**

---

#  Final Data Quality Assessment

## Overall Assessment

The overall data quality is **acceptable for analytical use after appropriate cleaning and validation**.

Most datasets have reliable primary keys and no duplicate rows. However, missing values are present in some important datasets, particularly **Orders, Reviews and Products**. The Geolocation dataset also contains a significant number of duplicate records that require careful validation before analysis.

The validation checks confirm that the core datasets are structurally consistent and suitable for further analysis after addressing the identified issues.

## Major Limitations

- Missing values are present in Orders, Reviews and Products.
- Reviews contain a relatively high number of missing values, which may affect review and customer feedback analysis.
- Products contain missing product attributes that may affect product-level analysis.
- Geolocation contains **261,831 duplicate rows**, which may influence geographic aggregations if not handled correctly.
- Some numerical fields may require additional outlier and business-rule validation before advanced analysis.

## Recommended Actions

1. Investigate and appropriately handle missing values.
2. Validate Geolocation duplicate records before aggregation or joining.
3. Check extreme and unusual numerical values.
4. Maintain primary key uniqueness across all transactional and master datasets.
5. Document every cleaning and transformation step.
6. Perform final validation after cleaning to ensure data integrity.
7. Use cleaned and validated datasets for downstream EDA, KPI analysis and visualization.

## Readiness for Analysis

**READY AFTER CLEANING**

The datasets can be used for further **Exploratory Data Analysis (EDA), Business Analysis, KPI Development and Dashboard Creation** after the identified missing values and duplicate geographic records are appropriately handled.