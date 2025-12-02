-- Creating the index for the optimizing the query.
CREATE INDEX IF NOT EXISTS idx_order_items_seller_order
ON order_items (seller_id, order_id);


ANALYZE order_items;
ANALYZE orders;
