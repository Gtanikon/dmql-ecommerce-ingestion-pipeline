
-- 1. Create READ-ONLY role (analyst)
CREATE ROLE analyst NOLOGIN;

-- Grant SELECT on all existing tables
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;

-- Ensure future tables also allow SELECT for analyst
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO analyst;


-- 2. Create READ-WRITE role (app_user)
CREATE ROLE app_user LOGIN PASSWORD 'app_password123';

-- Grant read and write privileges on all existing tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;

-- Ensure future tables also allow RW permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;


