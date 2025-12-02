-- Business question:
-- Which sellers make the most money on this platform, and how do they
-- compared with the overall average for the seller?
--
--Business explanation:
--   This query ranks sellers by total revenue, which is equal to the product price plus shipping.
--   The top 10 sellers. For each seller we show:
--     • number of distinct orders handled
--     • total items sold
--     • total revenue generated
--     • revenue_vs_avg = how far above or below the average seller revenue they are
--       (in currency units)
-- Operations / account-management can use this to identify high-value sellers,
-- Focus on relationship management, and identify under-performers compared to
--   the marketplace average.
WITH seller_metrics AS (
    SELECT
        s.seller_id,
        COUNT(DISTINCT o.order_id)          AS num_orders,
        COUNT(*)                            AS num_items_sold,     
        SUM(oi.price + oi.shipping_charges) AS total_revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY s.seller_id
)
SELECT
    seller_id,
    num_orders,
    num_items_sold,
    total_revenue,
    ROUND(
        total_revenue
        - AVG(total_revenue) OVER (),
        2
    ) AS revenue_vs_avg,
  
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM seller_metrics
ORDER BY total_revenue DESC
LIMIT 10;
