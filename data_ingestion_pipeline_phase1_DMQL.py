import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path


# 1. Connection details

DATABASE_URL = "postgresql+psycopg2://postgres:postgres@postgres:5432/ecommerce_db"

engine = create_engine(DATABASE_URL)


# 2. Paths to your CSV files

DATA_DIR = Path("Data_sets")

CUSTOMERS_CSV   = DATA_DIR / "Customers.csv"
ORDERS_CSV      = DATA_DIR / "Orders.csv"
ORDER_ITEMS_CSV = DATA_DIR / "OrderItems.csv"
PRODUCTS_CSV    = DATA_DIR / "Products.csv"
PAYMENTS_CSV    = DATA_DIR / "Payments.csv"

print("Reading CSV files from:", DATA_DIR.resolve())


# 3. Load CSVs

customers   = pd.read_csv(CUSTOMERS_CSV)
orders      = pd.read_csv(ORDERS_CSV)
order_items = pd.read_csv(ORDER_ITEMS_CSV)
products    = pd.read_csv(PRODUCTS_CSV)
payments    = pd.read_csv(PAYMENTS_CSV)

# ---- New: deduplicate based on primary keys ----
products  = products.drop_duplicates(subset=["product_id"])
customers = customers.drop_duplicates(subset=["customer_id"])
orders    = orders.drop_duplicates(subset=["order_id"])

print(" CSV files loaded and basic de-duplication applied")


# 4. Clean data


# Orders: ensure required dates are present and valid
orders = orders.dropna(
    subset=["order_purchase_timestamp", "order_estimated_delivery_date"]
)

orders["order_purchase_timestamp"] = pd.to_datetime(
    orders["order_purchase_timestamp"], errors="coerce"
)
orders["order_approved_at"] = pd.to_datetime(
    orders["order_approved_at"], errors="coerce"
)
orders["order_delivered_timestamp"] = pd.to_datetime(
    orders["order_delivered_timestamp"], errors="coerce"
)
orders["order_estimated_delivery_date"] = pd.to_datetime(
    orders["order_estimated_delivery_date"], errors="coerce"
).dt.date

orders = orders.dropna(
    subset=["order_purchase_timestamp", "order_estimated_delivery_date"]
)

valid_order_ids = set(orders["order_id"])

# Filter order_items and payments to valid orders
order_items = order_items[order_items["order_id"].isin(valid_order_ids)]
payments    = payments[payments["order_id"].isin(valid_order_ids)]

# Ensure non-negative amounts
order_items = order_items[
    (order_items["price"] >= 0) & (order_items["shipping_charges"] >= 0)
]
payments = payments[payments["payment_installments"] >= 1]
payments = payments[payments["payment_value"] >= 0]

# Sellers table from distinct seller_id values
sellers = order_items[["seller_id"]].drop_duplicates()

print(" Cleaning complete")


# 5. Load into PostgreSQL in FK-safe order

print(" Loading data into PostgreSQL...")

customers.to_sql("customers", engine, if_exists="append", index=False)
print("   customers loaded")

sellers.to_sql("sellers", engine, if_exists="append", index=False)
print("  sellers loaded")

products.to_sql("products", engine, if_exists="append", index=False)
print("   products loaded")

orders.to_sql("orders", engine, if_exists="append", index=False)
print("   orders loaded")

order_items.to_sql("order_items", engine, if_exists="append", index=False)
print("   order_items loaded")

payments.to_sql("payments", engine, if_exists="append", index=False)
print("   payments loaded")

print(" Data ingestion completed successfully.")
