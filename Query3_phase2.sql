-- Business question:
-- Which vendors have the poorest delivery performance, which is defined as the average
-- time from purchase to delivery?
--
-- Business explanation:
-- This query measures shipping performance per seller by:
--     • calculating delivery_delay_days for each delivered order
--       (order_delivered_timestamp - order_purchase_timestamp, in days)
--     • Calculating the average delivery_delay_days by each seller
--     • Counting the number of different delivered orders that each seller processed
--     • keeping only sellers with at least 20 delivered orders - to ensure stability
--     • Ranking the sellers according to the average delivery delay in descending order.
--       and returning the 10 slowest sellers.
-- This can be used by the logistics/ operations team to:
--    • Identify sellers that are causing a poor customer experience from slow shipping
--     • target SLAs, coaching, or penalties for the worst performers
--     • track delivery-time improvements after process or policy changes.

SELECT
    s.seller_id,
    s.num_orders,
    ROUND(s.avg_delivery_delay_days, 2) AS avg_delivery_delay_days,
    RANK() OVER (ORDER BY s.avg_delivery_delay_days DESC) AS slowest_seller_rank
FROM (
    SELECT
        oi.seller_id,
        COUNT(DISTINCT o.order_id) AS num_orders,
        (
            SELECT AVG(
                EXTRACT(
                    EPOCH FROM (o2.order_delivered_timestamp - o2.order_purchase_timestamp)
                ) / 86400.0
            )
            FROM orders o2
            JOIN order_items oi2
                ON o2.order_id = oi2.order_id
            WHERE o2.order_delivered_timestamp IS NOT NULL
              AND oi2.seller_id = oi.seller_id
        ) AS avg_delivery_delay_days
    FROM order_items oi
    JOIN orders o
        ON o.order_id = oi.order_id
    WHERE o.order_delivered_timestamp IS NOT NULL
    GROUP BY oi.seller_id
    HAVING COUNT(DISTINCT o.order_id) >= 20
) AS s
ORDER BY s.avg_delivery_delay_days DESC
LIMIT 10;

