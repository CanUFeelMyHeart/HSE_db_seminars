import psycopg2

conn = psycopg2.connect (
    host = "localhost", # Запускаем локально
    database = "test", # Имя БД
    user = "postgres", # От лица какого юзера делаем действия
    password = "1234", # Пароь для пользака
    port = 5432 # 5432 - по умолчанию
)

# conn.autocommit = True

cursor = conn.cursor()
# Bob = ('Bob', 42)
# people = [('Ivan', 35), ('Den', 26)]
#cursor.executemany("INSERT INTO people(name, age) VALUES (%s, %s)", people)
cursor.execute("SELECT * FROM people;")

#for person in cursor:
#    print(f"{person[1]} - {person[2]}")
# print(cursor.fetchmany(2))
print(cursor.fetchone())
conn.commit()
query_create = "CREATE DATABASE test;"

# cursor.execute(query_create)
print('Добавлены данные успешно')

cursor.close()
conn.close()

# with conn:
#     with cursor:
#         print(cursor.closed) # false = открыт
#         print("Коннект успешен")
# print(cursor.closed) # true - закрыт