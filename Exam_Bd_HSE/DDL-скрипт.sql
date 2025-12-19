
-- Таблица пользователей
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    registration_date DATE DEFAULT CURRENT_DATE
);


-- Таблица категорий товаров

CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);


-- Таблица товаров

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    category_id INT NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);


-- Таблица заказов

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- Таблица позиций заказа
CREATE TABLE OrderItems (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_order NUMERIC(10,2) NOT NULL CHECK (price_at_order >= 0),
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Таблица оплат
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    method VARCHAR(50) NOT NULL CHECK (method IN ('card', 'cash', 'online')),
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'completed', 'failed')),
    CONSTRAINT fk_order_payment FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Таблица доставок

CREATE TABLE Deliveries (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    address TEXT NOT NULL,
    shipped_date DATE,
    delivered_date DATE,
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled')),
    CONSTRAINT fk_order_delivery FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT check_dates CHECK (delivered_date IS NULL OR shipped_date IS NULL OR delivered_date >= shipped_date)
);


