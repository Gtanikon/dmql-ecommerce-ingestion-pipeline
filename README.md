 📦 DMQL Phase 1 – E-Commerce Data Engineering Pipeline

A complete data engineering pipeline built for **Phase 1 of the DMQL project**.
This repository contains the **ERD**, **3NF Justification Report**, **SQL schema**, **docker-compose configuration**, and the **Python ingestion script** that loads cleaned Olist e-commerce data into a PostgreSQL database running inside Docker.


##  Project Overview

This project demonstrates a fully functional **ETL + database setup pipeline**:

1. **Extract**

   * Reads raw CSV files from the Olist e-commerce dataset.
2. **Transform**

   * Cleans the data
   * Removes duplicates
   * Standardizes column names
   * Validates types
3. **Load**

   * Inserts all tables into a PostgreSQL instance running via Docker.
   * Database is automatically initialized by `schema.sql`.

The entire database can be recreated **using a single command**:

```bash
docker compose up -d
```

## Database Schema

The schema contains **five normalized tables**, all in **3NF**:

* `customers`
* `sellers`
* `products`
* `orders`
* `order_items`
* `payments`

Each table includes:

* Primary keys
* Foreign keys
* NOT NULL constraints
* Data-type checks
* Value checks (positive numbers, valid categories, etc.)

The schema is automatically executed when the PostgreSQL Docker container starts.

---

##  Running the Project with Docker

### **1. Start the PostgreSQL Database**

Run this command inside the project folder:

```bash
docker compose up -d
```

This will:

* Pull the PostgreSQL image
* Create a container named `ecommerce_postgres`
* Create a volume for persistent storage
* Auto-execute `schema.sql` to build tables

### **2. Verify the Database is Running**

```bash
docker ps
```

You should see a running container:
`ecommerce_postgres`

### **3. Connect to the Database**

```bash
docker exec -it ecommerce_postgres psql -U postgres -d ecommerce_db
```

Example check:

```sql
SELECT COUNT(*) FROM customers;
```
<img width="961" height="862" alt="image" src="https://github.com/user-attachments/assets/4f418344-143f-4bb6-97a8-ca31af4531f1" />


---

## Running the Python Ingestion Script

Run:

```bash
python data_ingestion_pipeline_phase1_DMQL.py
```

Script features:

* Loads all CSV files
* Removes duplicates
* Cleans NaNs / bad values
* Inserts into PostgreSQL with `SQLAlchemy`
* Prints logs for each table

Example output:

```
customers loaded
sellers loaded
products loaded
orders loaded
order_items loaded
payments loaded
Data ingestion completed successfully.
```

---

##  ERD (Entity-Relationship Diagram)

Your ERD illustrates:

* 3NF design
* Primary and foreign key relationships
* One-to-many connections between orders, items, sellers, and products
<img width="2025" height="1946" alt="mermaid-ai-diagram-2025-11-19-022538 1" src="https://github.com/user-attachments/assets/590f2e27-1d0f-44c3-8637-d0ecd4bbaa50" />


---

##  3NF Justification Summary

Each table is in **Third Normal Form** because:

1. **No duplicate fields** or repeating groups
2. **All non-key attributes depend completely** on their table's primary key
3. **No transitive dependencies**
4. Composite keys (like in `order_items`) uniquely identify each row

This avoids redundancy and supports scalable analytics.

---

##  Technologies Used

* **Python 3.10+**

  * pandas
  * SQLAlchemy
  * psycopg2
* **PostgreSQL 15**
* **Docker & Docker Compose**
* **ERD Tools** (Mermaid / Draw.io)
* **OlistPublic Dataset**

---

##  How to Reproduce the Whole Pipeline

1. Clone the repository
2. Put your CSV files inside `Data_sets/`
3. Run: `docker compose up -d`
4. Run: `python data_ingestion_pipeline_phase1_DMQL.py`
5. Connect to DB and validate counts
6. Done 

---

##  Deliverables Included

*  ERD
*  3NF justification document
*  SQL schema
*  Python ingestion script
*  docker-compose.yml
*  Working PostgreSQL database
*  All CSV processing code
*  README.md




