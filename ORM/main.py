from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String 
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.engine import URL 
from sqlalchemy.orm import Session, sessionmaker

DB_CONFIG = {
    "host": "localhost", # Запускаем локально
    "database": "test", # Имя БД
    "user": "postgres", # От лица какого юзера делаем действия
    "password": "1234", # Пароь для пользака
    "port": 5432 # 5432 - по умолчанию
}

postgresql_url = URL.create(
    drivername="postgresql",
    username=DB_CONFIG["user"],
    password=DB_CONFIG["password"],
    host=DB_CONFIG["host"],
    port=DB_CONFIG["port"],
    database=DB_CONFIG["database"]
)

# ("postgresql://user:password@localhost/database")
# postgresql://postgres:1234@localhost:5432/test

engine = create_engine(postgresql_url)

class Base(DeclarativeBase): pass

# __tablename__

class Person(Base):
    __tablename__ = "people"
    id = Column(Integer, primary_key=True)
    name = Column(String(45))
    age = Column(Integer)

Base.metadata.create_all(bind=engine)

print("Коннект успешен")

# Добавить запись - 1 человека
# Session = sessionmaker(bind=engine)
# with Session(autoflush=False, bind=engine) as db:
#     mike = Person(name='Mike', age=25)
#     db.add(mike)
#     db.commit() # autoflush=False
#     print(mike.id)

# with Session(autoflush=False, bind=engine) as db:
#     sam = Person(name='Sam', age=20)
#     kate = Person(name='Kate', age=20)
#     db.add_all([sam, kate])
#     db.commit()

with Session(autoflush=False, bind=engine) as db:
    test1 = Person(name='test1', age=50)
    test2 = Person(name='test2', age=60)
    db.add_all([test1, test2])
    db.commit()
    people = db.query(Person).all() # SELECT * FROM people
    for p in people:
        print(f"{p.id}. {p.name} - {p.age}")
    print('WHERE')
    young_people = db.query(Person).filter(Person.age < 30).all()
    for yp in young_people:
        print(f"{yp.id}. {yp.name} - {yp.age}")