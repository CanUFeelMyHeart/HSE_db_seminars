import psycopg2
from psycopg2.extras import RealDictCursor 
from psycopg2 import OperationalError  

DB_CONFIG = {
    "host": "localhost", # Запускаем локально
    "database": "myapp_db", # Имя БД
    "user": "postgres", # От лица какого юзера делаем действия
    "password": "1234", # Пароь для пользака
    "port": 5432 # 5432 - по умолчанию
}

def get_connection():
    return psycopg2.connect(**DB_CONFIG)

# CRUD - Create, Read, Update, Delete

def create_product(name: str, price: float, in_stock: bool = True):
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO products(name, price,in_stock) VALUES (%s, %s, %s);",
                    (name, price, in_stock)
                )
                conn.commit()
                print(f"Продукт {name} добавлен")
    except Exception as e:
        print(f"Error: {e}")

# read
def get_all_products():
    try:
        with get_connection() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                # ("Наушники", 2500.00, True) => {'name': "Наушники"}
                cur.execute('SELECT * FROM products;')
                records = cur.fetchall() # Вернуть все записи в формате списка
                return [dict(record) for record in records]
    except Exception as e:
        print(f"Error: {e}")

def update_products(product_id: int, name: str = None, price: float = None, in_stock: bool = None):
    fields = []
    values = []

    if name is not None:
        fields.append("name = %s")
        values.append(name)
    if price is not None:
        fields.append("price = %s")
        values.append(price)
    if in_stock is not None:
        fields.append("in_stock = %s")
        values.append(in_stock)
    if not fields:
        print(f'Нечего обновлять')
        return 
    values.append(product_id)

    query = f"UPDATE products SET {' ,'.join(fields)} WHERE id = %s"

    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(query, values)
                print(f'Продукт с id={product_id} обновился')
    except Exception as e:
        print(f"Error: {e}")

def delete_product(product_id: int):
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("DELETE FROM products WHERE id = %s",
                            (product_id,))
                print(f'Продукт с id={product_id} обновился')
    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    print("Чтение продуктов")
    # products = create_product("Наушники", 2500.00, True)
    # create_product("Наушники", 2500.00, True)
    # create_product("Наушники", 3500.00, True)
    update_products(1, price=2300,in_stock=False)
    delete_product(3)
    for product in get_all_products():
        print(product)