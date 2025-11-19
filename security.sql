
-- 1. Create READ-ONLY role 
CREATE ROLE analyst NOLOGIN;

-- Give SELECT read-only permissions on all tables
GRANT SELECT ON customers, sellers, products, orders, order_items, payments
TO analyst;

-- 2. Create READ-WRITE user role for app_user
CREATE ROLE app_user LOGIN PASSWORD 'app_password123';

-- Give full permissions: SELECT, INSERT, UPDATE, DELETE
GRANT SELECT, INSERT, UPDATE, DELETE ON customers, sellers, products, orders, order_items, payments
TO app_user;

-- Optional: Assign default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO analyst;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;
