# Data Catalog: Gold Layer

## Overview

The Gold layer is the final, business-ready layer. Its data is organized as a star schema or, more precisely, as the Fact Constellation Schema (Galaxy Schema) to support reporting and analytics, and it contains **dimension tables** (descriptive context) and a **fact table** (measurable business events).

---

## 1. gold.dim_products

**Purpose:** Contains information about products, categories, physical dimensions, and product card specifications..

---

## 2. gold.dim_sellers

**Purpose:** Contains basic information about sellers and their geographic locations.

---

## 3. gold.dim_customers

**Purpose:** Contains data on customers and their geographic locations.

---

## 4. gold.fact_order_items

**Purpose:** Contains detailed sales data for each line item in the order.

---

## 5. gold.fact_orders

**Purpose:** Contains summary information for each order

---

## 6. gold.fact_order_payments

**Purpose:** Contains data on transactions and payment methods for each order.

---
