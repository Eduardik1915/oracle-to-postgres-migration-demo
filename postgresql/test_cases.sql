--Visi testi veikti izmantojot datus no PostgreSQL/data.sql skripta

-- ============================================
-- Testi get_customer_orders procedūrai
-- =====================================
-- Nomainot procedūras pirmā parametra vertības būs dažādas uzvedības:
-- 1 -> Sekmīgi atgriež vērtības
-- 5 -> Atgriež kļūdu 'No orders found for this customer'
-- 99 -> Atgriež kļūdu 'Customer not found'
DO $$
DECLARE
	ref REFCURSOR;
	product_name products.product_name%TYPE;
   quantity orders.quantity%TYPE;
   order_date orders.order_date%TYPE;
BEGIN
    -- Nomaini vērtību šeit, lai pārbaudītu dažādus scenārijus
	call get_customer_orders(?, ref);

	LOOP
		FETCH ref INTO product_name, quantity, order_date;
		EXIT WHEN NOT FOUND;
	    RAISE NOTICE 'Result: %, %, %', product_name, quantity, order_date;
	END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Test Failed: %', SQLERRM;
END;
$$;


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
DO $$
BEGIN
    -- Nomaini vērtību šeit, lai pārbaudītu dažādus scenārijus
    CALL update_product_price_dynamic(?, ?);
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Test Failed: %', SQLERRM;
END;
$$;


-- ============================================
-- Function: get_customer_order_summary
-- Apraksts: atgriež klienta pasūtījumus
-- =====================================
--  1 -> atgriež pirkumu sarakstu
-- 99 -> Atgriež paziņojumu 'No orders found'
SELECT get_customer_order_summary(?);


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