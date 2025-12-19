--SELECT setval('users_user_id_seq', 1, false);
--SELECT setval('categories_category_id_seq', 1, false);
--SELECT setval('products_product_id_seq', 1, false);
--SELECT setval('orders_order_id_seq', 1, false);
--SELECT setval('payments_payment_id_seq', 1, false);
--SELECT setval('deliveries_delivery_id_seq', 1, false);

TRUNCATE TABLE	
	orderitems,
	payments,
	deliveries,
	orders,
	products,
	categories,
	users 
RESTART IDENTITY CASCADE;


INSERT INTO users (name, email, phone)
VALUES 
	('Иван','ivan@mail.ru', '+7-999-88-77-66'),
	('Ольга','olga@mail.ru', '+7-999-88-77-55'),
	('Петр','petr@mail.ru', '+7-999-88-77-88');
	
INSERT INTO categories (name, description)
VALUES 
	('Техника','Электронные и бытовые приборы'),
	('Книги','Книги и учебники'),
	('Одежда','Одежда для взрослых и детей');

SELECT * FROM categories;
INSERT INTO products (name, description, price, stock_quantity, category_id)
VALUES 
	('Кофеварка','Эл. кофеварка', 5000, 10, 1),
	('Чайник','Эл. чайник', 1500, 20, 1),
	('Миксер','Кухонный миксер', 3000, 5, 1),
	('Футболка','Хлопковая футболка', 800, 50, 3),
	('Война и Мир','Классическая литература, романы', 1200, 15, 2);
	

INSERT INTO orders (user_id, order_date, status)
VALUES 
	(1, '19.12.2025', 'paid'),
	(2, '18.12.2025', 'pending'),
	(3, '17.12.2025', 'shipped');

INSERT INTO orderitems(order_id, product_id, quantity, price_at_order)
VALUES 
	(1, 1, 1, 5000),
	(1, 2, 2, 1500),
	(2, 3, 1, 3000),
	(3, 4, 3, 800),
	(3, 5, 1, 1200);

INSERT INTO payments (order_id, payment_date, amount, "method", status)
VALUES
	(1, '19.12.2025', 8000, 'card', 'completed'),
	(2, '18.12.2025', 3000, 'online', 'pending'),
	(3, '17.12.2025', 3600, 'cash', 'completed');



INSERT INTO deliveries (order_id, address, shipped_date, delivered_date, status)
VALUES
	(1, 'ул. Ленина, 1', '20.12.2025', '22.12.2025', 'delivered'),
	(2, 'ул. Ленина, 5', NULL, NULL, 'pending'),
	(3, 'ул. Чехова, 10', '18.12.2025', NULL, 'shipped');
