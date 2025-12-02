-- Business question:
-- Which vendors have the poorest delivery performance, which is defined as the average
-- time from purchase to delivery?

-- Baseline implementation
--• Used a correlated subquery that for each seller re-joined the orders and
--     order_items to recompute AVG(delivery_delay_days).
--• This resulted in repeated work: the orders ↷ order_items join was evaluated
--     once per seller instead of once for the whole table.
--
-- Optimized implementation (this file, Optimized_Query3.sql):
-- • Calculates num_orders and avg_delivery_delay_days for every seller in a
--     single aggregate over the orders–order_items join
--   • Works with index:
--         idx_order_items_seller_order(seller_id, order_id)
--     which supports grouping by seller_id and efficient joining on order_id.
--   • Result: only one join + one GROUP BY over all rows; PostgreSQL can use a
--     Hash Join + GroupAggregate, reducing total work and execution time
--     compared to the baseline query.
SELECT
    s.seller_id,
    s.num_orders,
    ROUND(s.avg_delivery_delay_days, 2) AS avg_delivery_delay_days,
    RANK() OVER (ORDER BY s.avg_delivery_delay_days DESC) AS slowest_seller_rank
FROM (
    SELECT
        oi.seller_id,
        COUNT(DISTINCT o.order_id) AS num_orders,
        AVG(
            EXTRACT(
                EPOCH FROM (o.order_delivered_timestamp - o.order_purchase_timestamp)
            ) / 86400.0
        ) AS avg_delivery_delay_days
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_delivered_timestamp IS NOT NULL
    GROUP BY oi.seller_id
    HAVING COUNT(DISTINCT o.order_id) >= 20
) AS s
ORDER BY s.avg_delivery_delay_days DESC
LIMIT 10;
