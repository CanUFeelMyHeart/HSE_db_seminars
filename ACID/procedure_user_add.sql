
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
-- Начинаем транзакцию
	BEGIN
		-- Вызов процедуры
		CALL sp_user_add(
			'Мария',
			'Петрова',
			'maria@example.com',
			'Санкт-Петербург',
			NULL,
			'1992-05-01',
			res_msg
		);
		
		IF res_msg <> 'OK' THEN
			-- если есть ошибка, данные не добавляем
			RAISE NOTICE 'Ошибка при вставке: %', res_msg;
			ROLLBACK; -- откатывает к состонию "ДО транзакции"
		ELSE
			-- если все окей, то можно фиксировать изменения
			COMMIT; -- Сохранить, если все ок
			RAISE NOTICE 'Данные успешно добавлены';
		END IF;
	END;
END;
$$;

SELECT * FROM users u ;
SELECT * FROM profiles p ;



