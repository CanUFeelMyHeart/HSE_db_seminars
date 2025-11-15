
-- Удалание процедуры, если она уже есть
DROP PROCEDURE IF EXISTS sp_user_add;

-- Создаение процедуры
CREATE OR REPLACE PROCEDURE sp_user_add(
	-- users
	p_firstname VARCHAR,
	p_lastname VARCHAR,
	p_email VARCHAR,
	-- profiles
	p_hometown VARCHAR,
	p_photo_id INT,
	p_birthday DATE,
	OUT tran_result VARCHAR -- результат: ок или не ок
)
LANGUAGE plpgsql -- работаем с процедурами
AS $$ -- все, что между долларами - код, который будет исполняться
DECLARE 
	new_user_id INT; -- Сохраняем id после вставки нового юзера
BEGIN 
	INSERT INTO users (firstname, lastname, email)
	VALUES (p_firstname, p_lastname, p_email)
	RETURNING id INTO new_user_id; -- получить сгенерированный id нового человека
	
	-- Вставка в таблицу профилей
	INSERT INTO profiles (user_id, hometown, birthday, photo_id)
	VALUES (new_user_id, p_hometown, p_birthday, p_photo_id);

	tran_result := 'OK!';
	
EXCEPTION 
	WHEN OTHERS THEN -- ловит все ошибки целиком
		tran_result := 'УПС. Ошибка ' || SQLSTATE  || ' Текст ошибки: ' || SQLERRM;
			
END;
$$;

SELECT setval(pg_get_serial_sequence('users', 'id'), COALESCE(MAX(id), 0)) FROM users;

DO $$
DECLARE
	res_msg VARCHAR;
BEGIN
	CALL sp_user_add(
		'Иван',
		'Иванов',
		'ivan_new@example.com',
		'Москва',
		NULL,
		'1990-01-01',
		res_msg
	);
	RAISE NOTICE 'Результат: %', res_msg;
END;
$$;

SELECT * FROM users u ;
SELECT * FROM profiles p ;



