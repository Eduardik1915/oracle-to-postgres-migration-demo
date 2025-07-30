INSERT INTO customers (first_name, last_name, email, created_date, is_active) VALUES ('Jānis', 'Ozoliņš', 'janis.ozolins@example.com', SYSDATE, 1);
INSERT INTO customers (first_name, last_name, email, created_date, is_active) VALUES ('Līga', 'Bērziņa', 'liga.berzina@example.com', SYSDATE, 1);
INSERT INTO customers (first_name, last_name, email, created_date, is_active) VALUES ('Mārtiņš', 'Kalniņš', 'martins.kalnins@example.com', SYSDATE, 1);
INSERT INTO customers (first_name, last_name, email, created_date, is_active) VALUES ('Ilze', 'Liepa', 'ilze.liepa@example.com', SYSDATE, 0);
INSERT INTO customers (first_name, last_name, email, created_date, is_active) VALUES ('Artūrs', 'Krūmiņš', 'arturs.krumins@example.com', SYSDATE, 1);

INSERT INTO products (product_name, price) VALUES ('Koka galds', 120.00);
INSERT INTO products (product_name, price) VALUES ('Biroja krēsls', 89.99);
INSERT INTO products (product_name, price) VALUES ('Datora pele', 19.50);
INSERT INTO products (product_name, price) VALUES ('Monitors 24"', 159.90);
INSERT INTO products (product_name, price) VALUES ('Portatīvais dators', 799.00);

INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES (1, 2, 1, SYSDATE);
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES (2, 3, 2, SYSDATE);
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES (3, 5, 1, SYSDATE);
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES (4, 1, 1, SYSDATE);
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES (5, 4, 1, SYSDATE);
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES (1, 3, 1, SYSDATE);
