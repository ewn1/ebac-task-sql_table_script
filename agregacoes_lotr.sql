/********************************************************************************************
  DATABASE EVOLUTION SCRIPT (DDL) - RELATIONSHIPS & FOREIGN KEYS - THE MIDDLE-EARTH EDITION
  Course: EBAC Back-End Python
  Module: Introducao ao SQL
  Author: Edwin
  Description: Applying aggregation with "group by" and "sum" in existing tables
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


--- 4 MANIPULAÇÃO DE DADOS PARA TESTE DOS COMANDOS "GROUP BY" E "SUM"

INSERT INTO orders (customer_id, total_price) VALUES 
((SELECT id FROM customers WHERE name = 'Mithrandir'), 1003199.99);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(
    (SELECT id FROM orders WHERE customer_id = (SELECT id FROM customers WHERE name = 'Mithrandir') LIMIT 1),
    (SELECT id FROM products WHERE title = 'The One Ring'),
    1,
    999999.99
),
(
    (SELECT id FROM orders WHERE customer_id = (SELECT id FROM customers WHERE name = 'Mithrandir') LIMIT 1),
    (SELECT id FROM products WHERE title = 'Bow of the Galadhrim'),
    2,
    3200.00
);


--- 5 AGREGAÇÃO COM "GROUP BY" e "SUM" PARA DESCOBRIR A QUANTIDADE TOTAL DE ITENS VENDIDOS POR PRODUTO

SELECT 
    p.title AS produto,
    SUM(oi.quantity) AS total_unidades_vendidas
FROM products p
INNER JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.title
ORDER BY total_unidades_vendidas DESC;