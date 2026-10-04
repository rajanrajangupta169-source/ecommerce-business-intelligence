# 📊 ecommerce-business-intelligence

## 1. Dashboard Overview

The E-Commerce Business Intelligence Dashboard is developed using Microsoft Power BI to analyze and visualize e-commerce business performance.

The dashboard consists of two interactive pages that provide insights into:

- Overall business performance
- Revenue and sales trends
- Customer and order analysis
- Product category performance
- State-wise revenue
- Payment method distribution
- Order status analysis
- Seller performance
- Customer review analysis

**Dashboard Tool:** Microsoft Power BI  
**Dashboard Type:** Interactive Business Intelligence Dashboard  
**Pages:** 2

---

# 2. Dashboard Page 1 – Executive Overview

## Objective

The Executive Overview dashboard provides a summary of overall e-commerce business performance through KPI cards and interactive visualizations.

It helps business stakeholders understand revenue performance, customer activity, product performance, and order distribution.

## 2.1 KPI Cards

The dashboard contains six important KPI cards.

| KPI Name | Displayed Value | Description |
|---|---:|---|
| Total Revenue | 16.01M | Displays total revenue based on the selected revenue calculation |
| Average Order Value | 160.99 | Shows average revenue generated per order |
| Total Orders | 99K | Displays the total number of unique orders |
| Total Customers | 96K | Displays the total number of customers |
| Total Products | 33K | Shows the total number of unique products |
| Total Sellers | 3.095K | Displays the total number of unique sellers |


## 2.2 Monthly Revenue Comparison by Year

**Chart Type:** Line Chart

**Purpose:**

This visualization compares monthly revenue across different years.

**Business Questions:**
- How does monthly revenue change over time?
- Which months generate higher revenue?
- How does revenue compare between years?
- Are there any seasonal revenue patterns?

**Key Analysis:**

The chart helps identify revenue trends and compare business performance across different years.

## 2.3 Top 10 States by Revenue

**Chart Type:** Horizontal Bar Chart

**Purpose:**

Displays the top 10 states based on revenue contribution.

**Business Questions:**
- Which state generates the highest revenue?
- Which geographical regions contribute most to sales?
- How does revenue vary across states?

**Key Analysis:**

São Paulo (SP) appears as the highest-revenue state in the current dashboard.

## 2.4 Revenue by Payment Method

**Chart Type:** Donut Chart

**Purpose:**

Displays the distribution of payment value across different payment methods.

**Payment Categories:**
- Credit Card
- Boleto
- Voucher

**Business Questions:**
- Which payment method contributes the most revenue?
- What percentage of payment value comes from each method?
- Which payment methods are most commonly used?

**Key Analysis:**

Credit card payments represent the largest revenue contribution in the current visualization.

## 2.5 Order Status Distribution

**Chart Type:** Donut Chart

**Purpose:**

Analyzes the distribution of orders according to their current status.

**Order Status Categories:**
- Delivered
- Shipped
- Cancelled
- Unavailable

**Business Questions:**
- What percentage of orders are delivered?
- How many orders are cancelled?
- How many orders are still in transit?
- What is the overall order fulfillment performance?

**Key Analysis:**

Delivered orders represent approximately 97.02% of the orders displayed in the dashboard.

## 2.6 Top 10 Categories by Revenue

**Chart Type:** Horizontal Bar Chart

**Purpose:**

Identifies the top 10 product categories based on revenue.

**Business Questions:**
- Which product categories generate the highest revenue?
- Which categories contribute most to business sales?
- Which product categories have comparatively lower revenue?

**Key Analysis:**

The `watches_gifts` category appears among the highest revenue-generating categories in the current dashboard.

---

# 3. Dashboard Page 2 – Product, Seller & Review Analysis

## Objective

The second dashboard page provides detailed analysis of product category performance, seller revenue, customer reviews, and payment behavior.

It helps understand which categories and sellers contribute most to revenue and how customers rate their purchases.

## 3.1 Top 10 Product Categories by Revenue

**Chart Type:** Horizontal Bar Chart

**Purpose:**

Displays the top 10 product categories based on generated revenue.

**Business Questions:**
- Which categories generate the highest revenue?
- Which product categories perform better?
- How is revenue distributed across categories?

**Top Categories Displayed:**

| Product Category | Revenue |
|---|---:|
| beleza_saude | 1.26M |
| relogios_presentes | 1.21M |
| cama_mesa_banho | 1.04M |
| esporte_lazer | 0.99M |
| informatica_acessorios | 0.91M |
| moveis_decoracao | 0.73M |
| cool_stuff | 0.64M |
| utilidades_domesticas | 0.63M |
| automotivo | 0.59M |
| ferramentas_jardim | 0.49M |

**Key Analysis:**

The `beleza_saude` category has the highest displayed revenue among the categories shown.

## 3.2 Review Score Distribution

**Chart Type:** Column Chart

**Purpose:**

Analyzes customer reviews according to their review scores.

**Review Score Categories:**
- 1 Star
- 2 Stars
- 3 Stars
- 4 Stars
- 5 Stars

**Displayed Values:**

| Review Score | Total Reviews |
|---|---:|
| 1 Star | 11K |
| 2 Stars | 3K |
| 3 Stars | 8K |
| 4 Stars | 19K |
| 5 Stars | 57K |

**DAX Measure:**

```dax
Total Reviews =
COUNTROWS(reviews)
```

**Business Questions:**
- What is the most common review score?
- How many customers gave 5-star ratings?
- How many customers gave low ratings?
- What does the review distribution indicate about customer satisfaction?

**Key Analysis:**

Five-star reviews form the largest group in the current dashboard, indicating a positive review distribution.

## 3.3 Top 10 Sellers by Revenue

**Chart Type:** Horizontal Bar Chart

**Purpose:**

Identifies the top 10 sellers based on revenue contribution.

**Business Questions:**
- Which sellers generate the highest revenue?
- How does seller performance vary?
- Which sellers contribute most to total sales?

**Key Analysis:**

The chart compares the revenue contribution of the top-performing sellers and helps identify important sellers in the business.

## 3.4 Orders by Payment Method

**Chart Type:** Donut Chart

**Purpose:**

Displays the number of unique orders associated with different payment methods.

**Payment Categories:**
- Credit Card
- Boleto
- Voucher
- Debit Card
- Not Defined

**DAX Measure:**

```dax
Orders by Payment Method =
DISTINCTCOUNT(Payments[order_id])
```

**Business Questions:**
- Which payment method is associated with the highest number of orders?
- What percentage of orders use credit cards?
- How are orders distributed across payment methods?

**Key Analysis:**

Credit card is the largest payment category in the current visualization.

*Note: An order can have multiple payment records or payment methods. Therefore, category-wise distinct order counts may overlap.*

---

# 4. Dashboard Design & Features

The dashboard includes the following design and usability features:

- KPI cards for quick business performance monitoring.
- Line charts for monthly revenue comparisons.
- Bar charts for category, seller, and state analysis.
- Donut charts for payment and order status distribution.
- Column chart for customer review analysis.
- Consistent chart titles and labels.
- Interactive Power BI visuals.
- Two-page dashboard navigation.



## 5. Important Data Interpretation Notes

- The original Olist dataset uses Brazilian Real (BRL / R$).
- Payment value and product sales revenue are different measures.
- Average Order Value must use a consistent revenue definition and distinct order count.
- Payment method order counts may overlap when an order uses multiple payment methods.
- Review score distribution should count reviews rather than sum review scores.
- Monthly revenue trends should be checked for missing months and date relationship issues.

## 6. Conclusion

The ecommerce-business-intelligence Dashboard provides a consolidated view of business performance through two interactive Power BI report pages.

The first page focuses on executive-level KPIs, revenue trends, regional performance, payment value, order status, and product category revenue.

The second page provides deeper insights into product category performance, seller revenue, customer review distribution, and orders by payment method.

Together, these visualizations help stakeholders understand business performance, identify revenue opportunities, evaluate customer feedback, and support data-driven decision-making.

---

**Dashboard Developed By:** Rajan Gupta  
**Project:** ecommerce-business-intelligence
**Tool:** Microsoft Power BI