-- Без выполнения
EXPLAIN SELECT * FROM users u WHERE firstname = 'Austyn';

-- Выполняем запрос и получаем реальную оценку
EXPLAIN ANALYZE SELECT * FROM users u WHERE firstname = 'Austyn';

-- Выполняем запрос и получаем реальную оценку
EXPLAIN ANALYZE SELECT * FROM users u WHERE email = 'missouri87@example.org';

-- Выполняем запрос и получаем реальную оценку
EXPLAIN ANALYZE SELECT * FROM users u WHERE id = 1;

-- Индексы: WHERE, JOIN, ORDER BY, GROUP BY 

-- Выполняем запрос и получаем реальную оценку
EXPLAIN ANALYZE SELECT * FROM users u WHERE firstname = 'Austyn';

-- Запрос работает долго, так как есть полное сканирование таблицы. 
-- Вывод: можем наложить индекс

CREATE INDEX idx_users_firstname ON users(firstname); -- Индекс на firstname

-- Выполняем запрос и получаем реальную оценку
EXPLAIN ANALYZE SELECT * FROM users u WHERE firstname = 'Austyn';

-- CREATE INDEX ix_users_firstname ON users USING hash (firstname);

EXPLAIN ANALYZE SELECT * FROM messages m WHERE from_user_id = 1;

CREATE INDEX idx_users_messages ON messages(from_user_id); -- Индекс на firstname

EXPLAIN ANALYZE SELECT * FROM messages m WHERE from_user_id = 1 AND to_user_id = 2;

CREATE INDEX idx_messages_from_to ON messages(from_user_id, to_user_id); -- Индекс на firstname

EXPLAIN ANALYZE SELECT * FROM messages m WHERE from_user_id = 1 AND to_user_id = 2;

EXPLAIN ANALYZE SELECT * FROM communities  uc  WHERE name = 'tempora'

EXPLAIN ANALYZE
SELECT 
	m.id,
	m.body,
	m.created_at,
	u.firstname, 
	u.lastname
FROM messages m 
JOIN users u 
ON u.id = m.to_user_id
WHERE from_user_id = 1
ORDER BY m.created_at DESC;




