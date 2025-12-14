from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlalchemy import create_engine, text

app = FastAPI(title="DMQL Phase 3 API", version="1.0")

DATABASE_URL = "postgresql+psycopg2://postgres:postgres@postgres:5432/ecommerce_db"
engine = create_engine(DATABASE_URL, pool_pre_ping=True)


# Health check

@app.get("/")
def health():
    return {"status": "ok", "message": "DMQL Phase 3 API is running"}

# GET 1: Order status counts (your working endpoint)

@app.get("/stats/order-status", summary="Order Status Counts")
def order_status_counts():
    q = """
    SELECT order_status, COUNT(*) AS count
    FROM orders
    GROUP BY order_status
    ORDER BY COUNT(*) DESC;
    """
    with engine.connect() as conn:
        rows = conn.execute(text(q)).mappings().all()
    return rows

# GET 2: List customers (with limit)

@app.get("/customers", summary="List customers")
def list_customers(limit: int = 20):
    q = """
    SELECT customer_id, customer_city, customer_state
    FROM customers
    LIMIT :limit;
    """
    with engine.connect() as conn:
        rows = conn.execute(text(q), {"limit": limit}).mappings().all()
    return rows


# GET 3: Get one customer by id

@app.get("/customers/{customer_id}", summary="Get a customer by ID")
def get_customer(customer_id: str):
    q = """
    SELECT customer_id, customer_zip_code_prefix, customer_city, customer_state
    FROM customers
    WHERE customer_id = :cid;
    """
    with engine.connect() as conn:
        row = conn.execute(text(q), {"cid": customer_id}).mappings().first()

    if not row:
        raise HTTPException(status_code=404, detail="Customer not found")

    return row


# POST: create a note (safe data modification)

class NoteIn(BaseModel):
    note: str

@app.post("/notes", summary="Create a note")
def create_note(payload: NoteIn):
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS api_notes (
        id SERIAL PRIMARY KEY,
        note TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT NOW()
    );
    """
    insert_sql = """
    INSERT INTO api_notes (note)
    VALUES (:note)
    RETURNING id, note, created_at;
    """

    with engine.begin() as conn:
        conn.execute(text(create_table_sql))
        row = conn.execute(text(insert_sql), {"note": payload.note}).mappings().first()

    return row


# GET: list notes (so you can verify POST worked)

@app.get("/notes", summary="List notes")
def list_notes(limit: int = 20):
    q = """
    SELECT id, note, created_at
    FROM api_notes
    ORDER BY id DESC
    LIMIT :limit;
    """
    with engine.connect() as conn:
        rows = conn.execute(text(q), {"limit": limit}).mappings().all()
    return rows
