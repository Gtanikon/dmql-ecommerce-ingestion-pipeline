CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_zip_code_prefix INTEGER NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state CHAR(2) NOT NULL,
    CHECK (customer_zip_code_prefix > 0)
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_weight_g INTEGER CHECK (product_weight_g >= 0),
    product_length_cm INTEGER CHECK (product_length_cm >= 0),
    product_height_cm INTEGER CHECK (product_height_cm >= 0),
    product_width_cm INTEGER CHECK (product_width_cm >= 0)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_timestamp TIMESTAMP,
    order_estimated_delivery_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,
    price NUMERIC NOT NULL CHECK (price >= 0),
    shipping_charges NUMERIC NOT NULL CHECK (shipping_charges >= 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE payments (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type VARCHAR(50) NOT NULL,
    payment_installments INTEGER NOT NULL CHECK (payment_installments >= 1),
    payment_value NUMERIC NOT NULL CHECK (payment_value >= 0),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);
