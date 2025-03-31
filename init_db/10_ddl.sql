-- Измерение: География (для нормализации адресов)
CREATE TABLE dim_locations (
    location_sk SERIAL PRIMARY KEY,
    postal_code VARCHAR(50),
    city VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    UNIQUE (postal_code, city, state, country)
);

-- Измерение: Покупатели
CREATE TABLE dim_customers (
    customer_sk SERIAL PRIMARY KEY,
    customer_nk_id INTEGER UNIQUE,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    age INTEGER,
    email VARCHAR(255),
    location_sk INTEGER REFERENCES dim_locations(location_sk)
);

-- Измерение: Питомцы покупателей (связано с Покупателями - Снежинка)
CREATE TABLE dim_customer_pets (
    pet_sk SERIAL PRIMARY KEY,
    customer_sk INTEGER NOT NULL REFERENCES dim_customers(customer_sk),
    pet_type VARCHAR(50),
    pet_name VARCHAR(255),
    pet_breed VARCHAR(255),
    pet_category VARCHAR(50),
    UNIQUE (customer_sk, pet_type, pet_name, pet_breed)
);

-- Измерение: Продавцы
CREATE TABLE dim_sellers (
    seller_sk SERIAL PRIMARY KEY,
    seller_nk_id INTEGER UNIQUE,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    location_sk INTEGER REFERENCES dim_locations(location_sk)
);

-- Измерение: Поставщики
CREATE TABLE dim_suppliers (
    supplier_sk SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE,
    contact_person VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    address VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255)
);

-- Измерение: Товары
CREATE TABLE dim_products (
    product_sk SERIAL PRIMARY KEY,
    product_nk_id INTEGER UNIQUE,
    name VARCHAR(255),
    category VARCHAR(255),
    current_price NUMERIC(10, 2),
    current_quantity INTEGER,
    weight NUMERIC(10, 2),
    color VARCHAR(50),
    size VARCHAR(50),
    brand VARCHAR(255),
    material VARCHAR(255),
    description TEXT,
    rating NUMERIC(3, 1),
    reviews INTEGER,
    release_date DATE,
    expiry_date DATE
);

-- Измерение: Магазины
CREATE TABLE dim_stores (
    store_sk SERIAL PRIMARY KEY,
    name VARCHAR(255),
    location_details VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(255),
    location_sk INTEGER REFERENCES dim_locations(location_sk),
    UNIQUE (name, location_details, location_sk)
);

-- Измерение: Дата
CREATE TABLE dim_dates (
    date_sk INTEGER PRIMARY KEY,
    full_date DATE UNIQUE,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    month_name VARCHAR(20),
    day INTEGER,
    day_of_week INTEGER,
    day_name VARCHAR(20),
    week_of_year INTEGER
);

-- Таблица фактов: Продажи
CREATE TABLE fact_sales (
    sale_id BIGSERIAL PRIMARY KEY,
    date_sk INTEGER NOT NULL REFERENCES dim_dates(date_sk),
    customer_sk INTEGER NOT NULL REFERENCES dim_customers(customer_sk),
    pet_sk INTEGER NOT NULL REFERENCES dim_customer_pets(pet_sk),
    seller_sk INTEGER NOT NULL REFERENCES dim_sellers(seller_sk),
    product_sk INTEGER NOT NULL REFERENCES dim_products(product_sk),
    store_sk INTEGER NOT NULL REFERENCES dim_stores(store_sk),
    supplier_sk INTEGER NOT NULL REFERENCES dim_suppliers(supplier_sk),
    quantity_sold INTEGER NOT NULL,
    unit_price_at_sale NUMERIC(10, 2),
    total_price_at_sale NUMERIC(10, 2) NOT NULL,
    raw_data_id INTEGER
);

-- Индексы для ускорения JOIN'ов в таблице фактов
CREATE INDEX idx_fact_sales_date_sk ON fact_sales(date_sk);
CREATE INDEX idx_fact_sales_customer_sk ON fact_sales(customer_sk);
CREATE INDEX idx_fact_sales_pet_sk ON fact_sales(pet_sk);
CREATE INDEX idx_fact_sales_seller_sk ON fact_sales(seller_sk);
CREATE INDEX idx_fact_sales_product_sk ON fact_sales(product_sk);
CREATE INDEX idx_fact_sales_store_sk ON fact_sales(store_sk);
CREATE INDEX idx_fact_sales_supplier_sk ON fact_sales(supplier_sk);