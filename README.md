# DMQL Project – End-to-End Data Engineering and Application Pipeline

A complete **end-to-end data engineering and application pipeline** built for the **DMQL course**, covering **Phase 1 (Data Modeling & Ingestion)**, **Phase 2 (Querying & Optimization)**, and **Phase 3 (Application Layer – REST API)**.

This repository demonstrates the full lifecycle of a data system:
- Designing a normalized OLTP database schema
- Ingesting and cleaning raw e-commerce data
- Writing and optimizing SQL queries
- Exposing the data through a **RESTful API built with FastAPI**

The entire system is **fully automated**, containerized using **Docker Compose**, and can be executed using a **single command**.


---

## Project Overview

This project demonstrates a **complete end-to-end data pipeline with an API layer**:

1. **Extract**
   - Reads raw CSV files from the e-commerce dataset

2. **Transform**
   - Cleans data
   - Removes duplicates
   - Validates timestamps and numeric fields
   - Enforces foreign key consistency

3. **Load**
   - Inserts cleaned data into PostgreSQL using SQLAlchemy
   - Database schema is initialized automatically using `schema.sql`

4. **Serve (Phase 3)**
   - Exposes data via REST API endpoints using FastAPI
   - Supports both data retrieval (GET) and modification (POST)
   - Provides auto-generated Swagger documentation

The entire pipeline is executed using **one command**:

```bash
docker compose up --build
````

---

## Project Architecture

The project consists of **three Docker services**:

### 1. PostgreSQL

* Stores all transactional e-commerce data
* Schema initialized automatically at startup

### 2. Data Ingestion Service

* Loads CSV files into PostgreSQL
* Applies cleaning and validation
* Runs once and exits successfully

### 3. FastAPI Service

* Exposes REST endpoints
* Connects to PostgreSQL using SQLAlchemy
* Provides Swagger UI for API exploration

---

## Folder Structure

```
DMQL_Phase_1/
├── docker-compose.yml
├── README.md
├── schema.sql
├── data_ingestion_pipeline_phase1_DMQL.py
├── Data_sets/
│   ├── Customers.csv
│   ├── Orders.csv
│   ├── OrderItems.csv
│   ├── Products.csv
│   └── Payments.csv
└── api/
    └── main.py
```

---

## Running the Project with Docker

### 1. Start the Entire Pipeline

Run the following command from the project root:

```bash
docker compose up --build
```

This command will:

* Start PostgreSQL
* Initialize the database schema
* Automatically ingest all CSV data
* Launch the FastAPI application

No manual database setup or script execution is required.

---

### 2. Verify Containers Are Running

```bash
docker ps
```

You should see:

* `ecommerce_postgres`
* `ecommerce_ingest` (completed)
* `dmql_api`

---

## Accessing the API

Once Docker Compose is running, access the API using:

* **Swagger UI:**
  [http://localhost:8000/docs](http://localhost:8000/docs)

* **OpenAPI JSON:**
  [http://localhost:8000/openapi.json](http://localhost:8000/openapi.json)

* **Health Check:**
  [http://localhost:8000/](http://localhost:8000/)

---

## Implemented API Endpoints

### GET Endpoints

* `/stats/order-status`
  Returns order counts grouped by order status

* `/customers`
  Lists customers (supports `limit` query parameter)

* `/customers/{customer_id}`
  Retrieves a specific customer by ID

* `/notes`
  Lists notes created through the API

### POST Endpoint

* `/notes`
  Inserts a new note into the database to demonstrate safe data modification

---

## Data Ingestion Pipeline

The ingestion pipeline:

* Reads CSV files from `Data_sets/`
* Removes duplicate primary keys
* Validates timestamps and numeric values
* Ensures foreign key integrity
* Loads data in a safe dependency order

The pipeline is **automatically triggered** by Docker Compose.

---

## Database Schema

The schema contains **fully normalized tables (3NF)**:

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
* Data-type validation
* Value constraints

The schema is executed automatically when PostgreSQL starts.

---

## Screenshots

Screenshots demonstrating:

* Docker Compose execution
* Swagger UI
* Successful GET and POST API responses

(Attached below)

<!-- Screenshots intentionally preserved as provided -->

````

⬆️ **Leave your screenshots exactly below this section**, just like in Phase 1.

---

```md
---

## Demo Video

A short demo video showing:
- Docker Compose execution
- Swagger UI access
- API endpoint execution

Demo video link: (to be added)

---

## Technologies Used

- **Python 3.11**
  - pandas
  - SQLAlchemy
  - psycopg2
  - FastAPI
- **PostgreSQL 15**
- **Docker & Docker Compose**
- **Swagger / OpenAPI**

---

## How to Reproduce the Entire Pipeline

1. Clone the repository
2. Ensure Docker is running
3. Navigate to the project root
4. Run:

```bash
docker compose up --build
````

5. Open Swagger UI and test endpoints
6. Done

---

## Deliverables Included

* Dockerized PostgreSQL database
* Automated data ingestion pipeline
* REST API built with FastAPI
* Swagger documentation
* SQL schema
* ER diagram
* CSV processing code
* README.md



