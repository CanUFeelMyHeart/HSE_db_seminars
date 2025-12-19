-- CTE (With)

-- Топ - 3 товаров, которые принесли наибольшую прибыль

WITH product_revenue AS (
	SELECT
		p.product_id,
		p.name,
		SUM(o.quantity * o.price_at_order) AS total_rev,
		SUM(o.quantity) AS total_quant
	FROM products p
	JOIN orderitems o ON o.product_id = p.product_id
	GROUP BY p.product_id, p.name
)

SELECT * 
FROM product_revenue
ORDER BY total_rev DESC
LIMIT 3;

-- 5. Джоин 3 табл
SELECT 
	u.user_id,
	u.name,
	u.email,
	o.order_date,
	o.order_id,
	o.status,
	p.amount,
	p.status,
	d.status,
	d.address
FROM users u 
JOIN orders o ON u.user_id = o.user_id
LEFT JOIN payments p ON p.order_id  = o.order_id
LEFT JOIN deliveries d ON o.order_id = d.order_id;

-- 6. Оконки

-- Аналитика по заказам:
-- 1. Порядковый номер заказа пользака
-- 2. Ранг заказа по выручке
-- 3. Суммарная выручка по заказам

SELECT 
	u.user_id,
	u.name,
	o.order_id,
	SUM(o2.quantity * o2.price_at_order) AS total_rev,
	ROW_NUMBER() OVER(PARTITION BY u.user_id ORDER BY o.order_date) AS order_number,
	DENSE_RANK() OVER(PARTITION BY u.user_id ORDER BY 
	SUM(o2.quantity * o2.price_at_order) DESC) AS revenue_rank,
	SUM(SUM(o2.quantity * o2.price_at_order)) OVER(PARTITION BY u.user_id)
	AS total_user_rev
FROM orders o 
JOIN users u ON o.user_id = u.user_id 
JOIN orderitems o2 ON o2.order_id = o.order_id 
GROUP BY u.user_id, u.name, o.order_id
ORDER BY u.user_id, order_number;

-- 6. 

EXPLAIN ANALYZE
SELECT 
	u.user_id,
	u.name,
	u.email,
	o.order_date,
	o.order_id,
	o.status,
	p.amount,
	p.status,
	d.status,
	d.address
FROM users u 
JOIN orders o ON u.user_id = o.user_id
LEFT JOIN payments p ON p.order_id  = o.order_id
LEFT JOIN deliveries d ON o.order_id = d.order_id;







