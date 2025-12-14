
# DMQL Phase 3 – Application Layer (REST API)

## Project Overview
This project implements the Application Layer for the DMQL course using a REST API built with FastAPI. The API provides access to an OLTP PostgreSQL database populated through an automated data ingestion pipeline. The entire system is fully containerized and runs using a single Docker Compose command.

---

## Technology Stack
- Python 3.11  
- FastAPI  
- PostgreSQL  
- SQLAlchemy  
- Docker & Docker Compose  

---

## Project Architecture
The project consists of three Docker services:

- PostgreSQL: Stores ecommerce transactional data and initializes the database schema  
- Data Ingestion Service: Automatically loads CSV data into PostgreSQL and exits after completion  
- FastAPI Service: Exposes REST endpoints and provides Swagger documentation  

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

````

---

## How to Run the Project

### Prerequisites
- Docker
- Docker Compose

### Steps
1. Navigate to the project root directory
2. Run the following command:

```bash
docker compose up --build
````

This command automatically:

* Starts PostgreSQL
* Loads data into the database
* Launches the FastAPI application

No manual execution is required.

---

## Accessing the API

Once the containers are running, open the following URLs in your browser:

* Swagger UI: [http://localhost:8000/docs](http://localhost:8000/docs)
* Health Check: [http://localhost:8000/](http://localhost:8000/)

---

## Implemented API Endpoints

### GET Endpoints

* `/stats/order-status` – Returns order counts grouped by order status
* `/customers` – Lists customers (supports a `limit` parameter)
* `/customers/{customer_id}` – Retrieves a customer by ID
* `/notes` – Lists notes created via the API

### POST Endpoint

* `/notes` – Creates a new note and stores it in the database

---

## Data Ingestion

Data is automatically loaded from CSV files located in the `Data_sets/` folder.
The ingestion pipeline performs:

* Primary key de-duplication
* Data cleaning and validation
* Foreign key–safe insertion order

The pipeline runs automatically when Docker Compose is executed.

---

## Screenshots

Screenshots demonstrating Docker execution, Swagger UI, and successful API requests are included in the `screenshots/` folder.

---

## Demo Video

A short demo video showing Docker Compose execution, Swagger UI access, and API request execution is available at:

**(Add demo video link here)**

---


