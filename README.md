# Data Cleaning & Transformation Portfolio

## 🧹 Section: MySQL Data Cleaning

### 📦 Project: E-commerce Sales Data Transformation
This project demonstrates an end-to-end data cleaning and transformation pipeline executed within a MySQL database. The goal was to take a raw, unstructured "messy" CSV file containing e-commerce transaction logs and convert it into a strictly typed, consistent, and validated dataset ready for advanced analytics and BI tool integration.

---

### 📂 Repository Structure
```text
Data-Cleaning-Projects/
└── MySQL-Data-Cleaning/
    └── project-name/
        ├── messy_ecommerce_sales_data.csv    # Original untransformed dataset
        ├── cleaned_ecommerce_sales_data.csv  # Final cleaned data (exported)
        └── сleaning_script.sql               # Production-ready SQL script
```

---

### 🛠️ Key Cleaning Procedures & SQL Techniques

#### 1. Direct CSV Ingestion & Architecture Setup
* Leveraged the `LOAD DATA INFILE` command for optimal and high-performance ingestion of bulk text data into a `staging` schema.
* Initially mapped columns to loose `VARCHAR` data types to prevent data truncation during the raw import phase, isolating inconsistencies for targeted cleaning.

#### 2. Standardization of Categorical Values
* Fixed case-sensitivity duplicates (e.g., merging variations like `sports` and `Sports` into a unified format).
* Implemented structural text conversion using a robust string manipulation combination to safely capitalize only the first letter of each category without corrupting inner characters:
  ```sql
  CONCAT(UPPER(SUBSTRING(Category, 1, 1)), SUBSTRING(Category, 2))
  ```

#### 3. Advanced Pattern Matching via Regular Expressions (RegEx)
* Automated the identification of data-entry anomalies within currency fields (such as text representations like `'four hundred'`).
* Handled spacing variables within multi-word text columns using customized SQL regex patterns:
  ```sql
  WHERE Price REGEXP '^[[:alpha:] ]+\$'
  ```

#### 4. Type Enforcement & Precision Optimization
* Rebuilt unstructured date strings (`'Jan 5 2023'`) into standardized MySQL `DATE` formats (`YYYY-MM-DD`) using exact masking configurations in `STR_TO_DATE()`.
* Upgraded numeric fields (`Price`, `Total`) from general text variables into high-precision `DECIMAL(10,2)` schema attributes. This migration enforces strict financial precision, prevents float-rounding data loss, and auto-appends trailing pennies (`389.5` ➔ `389.50`).

#### 5. Dynamic Metadata Analysis & Missing Value Verification
* Engineered a dynamic SQL generator query querying the database's `information_schema.COLUMNS` repository.
* This metadata script automatically builds and executes mass string-concatenation validations (`CONCAT_WS`) to sniff out hidden blanks (`''`), explicit `NULL` states, and invalid text placeholder crumbs (`'N/A'`, `'none'`, `'null'`) natively across all existing schema vectors simultaneously.

---

### 🚀 Future Roadmap
* [ ] Integrate the verified `cleaned_ecommerce_sales_data.csv` pipeline with Power BI / Tableau to establish interactive business dashboards.
* [ ] Build an automated Python pipeline using Pandas to handle raw CSV validation pre-loading.
