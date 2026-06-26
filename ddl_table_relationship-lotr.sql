/********************************************************************************************
  DATABASE EVOLUTION SCRIPT (DDL) - RELATIONSHIPS & FOREIGN KEYS - THE MIDDLE-EARTH EDITION
  Course: EBAC Back-End Python
  Module: Introducao ao SQL
  Author: Edwin
  Description: Applying 1:1, 1:N, and N:N relationships to existing tables
********************************************************************************************/

--- 1 RELACIONAMENTO 1:1 (Products <-> Stock)

ALTER TABLE stock 
ADD CONSTRAINT fk_stock_product 
FOREIGN KEY (product_id) REFERENCES products(id)
ON DELETE CASCADE;

ALTER TABLE stock 
ADD CONSTRAINT uq_stock_product 
UNIQUE (product_id);


--- 2 RELACIONAMENTO 1:N (Customers <-> Orders)

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT fk_orders_customer 
        FOREIGN KEY (customer_id) REFERENCES customers(id) 
        ON DELETE SET NULL
);


--- 3 RELACIONAMENTO N:N (Orders <-> Products)

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_items_order 
        FOREIGN KEY (order_id) REFERENCES orders(id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_items_product 
        FOREIGN KEY (product_id) REFERENCES products(id) 
        ON DELETE RESTRICT
);