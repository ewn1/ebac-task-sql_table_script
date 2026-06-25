/*******************************************************************************
  DATABASE MANIPULATION SCRIPT (DML) - THE MIDDLE-EARTH EDITION
  Course: EBAC Back-End Python
  Module: Introducao ao SQL
  Author: Edwin
  Description: Data insertion and manipulation
*******************************************************************************/

-- DATA INSERTION

-- 1 Customers
INSERT INTO customers (name, email, phone) VALUES
('Sauron', 'thedarklord@mordor.com', '0000-0000'),
('Mithrandir', 'gandalf.thegrey@valinor.org', '7777-7777'),
('Galadriel', 'lady.lothlorien@valinor.org', '9999-9999'),
('Legolas Leaf Green', 'legolas@woodland.realm', '1111-1111'),
('Witch King of Dol Guldur', 'nazgul1@minasmorgul.com', '0000-0001');

-- 2. Inserting Magical Products 
INSERT INTO products (title, price, description) VALUES
('The One Ring', 999999.99, 'One Ring to rule them all, One Ring to find them.'),
('Glamdring (Foe-hammer)', 4500.00, 'Fabled sword forged in Gondolin, glows blue near orcs.'),
('Phial of Galadriel', 12500.50, 'A light for you in dark places, when all other lights go out.'),
('Bow of the Galadhrim', 3200.00, 'A great bow made of mallorn-wood, strung with elf-hair.'),
('Morgul-blade', 850.00, 'A deadly poisoned dagger used by the Nazgûl.');

-- 3. Inserting Stock Levels
INSERT INTO stock (product_id, quantity) VALUES
((SELECT id FROM products WHERE title = 'The One Ring'), 1),
((SELECT id FROM products WHERE title = 'Glamdring (Foe-hammer)'), 1),
((SELECT id FROM products WHERE title = 'Phial of Galadriel'), 3),
((SELECT id FROM products WHERE title = 'Bow of the Galadhrim'), 5),
((SELECT id FROM products WHERE title = 'Morgul-blade'), 9);


-- 4. MANIPULATION

-- SELECT with WHERE and IN
SELECT * FROM customers 
WHERE email IN ('gandalf.thegrey@valinor.org', 'lady.lothlorien@valinor.org');

-- UPDATE
UPDATE stock 
SET quantity = quantity - 1, last_update = CURRENT_TIMESTAMP
WHERE product_id = (SELECT id FROM products WHERE title = 'Phial of Galadriel');

-- SUBQUERY
SELECT id, title, price 
FROM products 
WHERE id = (
    SELECT product_id 
    FROM stock 
    ORDER BY quantity DESC 
    LIMIT 1
);

-- DELETE with WHERE
DELETE FROM stock 
WHERE product_id = (SELECT id FROM products WHERE title = 'Morgul-blade');

DELETE FROM products 
WHERE title = 'Morgul-blade';