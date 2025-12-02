-- Business question:
-- Which product categories are the most valuable on a per-order basis?
--
-- Business explanation:
-- This query aggregates revenue at the product-category level and calculates
-- revenue_per_order = total revenue / number of distinct orders in that category.
-- It:
--     • considers only categories with at least 50 orders, to avoid noisy tiny groups
--     • ranks categories by revenue_per_order
--     • returns the top 10 categories
-- Category management and pricing teams can leverage the same to
--     • identify premium / high-value categories
--     • determine where to invest marketing dollars, drive promotions, or expand assortment
--     • Flag low value categories that may need repricing or cost control.

WITH category_stats AS (
    SELECT
        p.product_category_name,
        COUNT(DISTINCT o.order_id)              AS num_orders,
        SUM(oi.price + oi.shipping_charges)     AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY p.product_category_name
)
SELECT
    product_category_name,
    num_orders,
    total_revenue,
    ROUND(total_revenue::numeric / NULLIF(num_orders, 0), 2) AS revenue_per_order,
    RANK() OVER (
        ORDER BY (total_revenue::numeric / NULLIF(num_orders, 0)) DESC
    ) AS rev_per_order_rank
FROM category_stats
WHERE num_orders >= 50
ORDER BY revenue_per_order DESC
LIMIT 10;
