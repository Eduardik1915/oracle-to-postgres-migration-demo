--Visi testi veikti izmantojot datus no Oracle/data.sql skripta

-- ============================================
-- Testi get_customer_orders procedūrai
-- Apraksts: atgriež klienta pasūtījumus caur OUT-kursoru
-- =====================================
-- Nomainot procedūras pirmā parametra vertības būs dažādas uzvedības:
-- 1 -> Sekmīgi atgriež vērtības
-- 5 -> Atgriež kļūdu 'No orders found for this customer'
-- 99 -> Atgriež kļūdu 'Customer not found'
DECLARE
   cur SYS_REFCURSOR;
   product_name products.product_name%TYPE;
   quantity orders.quantity%TYPE;
   order_date orders.order_date%TYPE;
BEGIN
    -- Nomaini vērtību šeit, lai pārbaudītu dažādus scenārijus
    get_customer_orders(?, cur);
	
	LOOP
		FETCH cur INTO product_name, quantity, order_date;
		EXIT WHEN cur%NOTFOUND;
	    DBMS_OUTPUT.PUT_LINE('Result: ' || product_name || ', ' || quantity || ', ' || order_date);
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Test Failed: ' || SQLERRM);
END;


-- ============================================
-- Procedure: update_product_price_dynamic
-- Apraksts: atjauno produkta cenu caur dinamisko SQL
-- ============================================
-- Testi ar pirmo procedūras parametru:
--   1 -> Sekmīgi nomaina cenu
--   99 -> Atgriež kļūdu 'No product updated. Possibly invalid ID'
-- Testi ar otro procedūras parametru:
--   Pozitīva -> Sekmīgi nomaina cenu
--   Negatīva -> Atgriež kļūdu 'Price must be positive'
BEGIN
    -- Nomaini vērtību šeit, lai pārbaudītu dažādus scenārijus
    update_product_price_dynamic(?, ?);
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Test Failed: ' || SQLERRM);
END;


-- ============================================
-- Function: get_customer_order_summary
-- Apraksts: atgriež klienta pasūtījumus
-- =====================================
--  1 -> atgriež pirkumu sarakstu
-- 99 -> Atgriež paziņojumu 'No orders found'
SELECT get_customer_order_summary(?) FROM dual;


-- ============================================
-- Trigger: trg_orders_quantity_update
-- Apraksts: saglabā kolonnas orders.quantity izmaiņas old_quantity_log tabulā
-- =====================================
INSERT INTO orders (order_id, customer_id, product_id, quantity)
VALUES (200, 1, 2, 3);

UPDATE orders
SET quantity = 5
WHERE order_id = 200;

SELECT * FROM old_quantity_log;