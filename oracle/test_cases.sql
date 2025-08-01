-- ============================================
-- Testi get_customer_orders procedūrai
-- Apraksts: atgriež klienta pasūtījumus caur OUT-kursoru
-- =====================================
-- Nomainot procedūras pirmā parametra vertības būs dažādas uzvedības:
-- 1 -> Sekmīgi atgriež vērtības
-- 5 -> Atgriež kļūdu 'No orders found for this customer'
-- 6 -> Atgriež kļūdu 'Customer not found'
DECLARE
   cur SYS_REFCURSOR;
   product_name products.product_name%TYPE;
   quantity orders.quantity%TYPE;
   order_date orders.order_date%TYPE;
BEGIN
    -- Nomaini vērtību šeit, lai pārbaudītu dažādus scenārijus
    get_customer_orders(1, cur);
	
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
-- Testi ar pirmo procedūras parametru.
-- 1. Vērtība: 1 -> Sekmīgi nomaina cenu
-- 2. Vērtība: 6 -> Atgriež kļūdu 'No product updated. Possibly invalid ID'
-- Testi ar otro procedūras parametru.
-- 1. Vērtība: pozitīva -> Sekmīgi nomaina cenu
-- 2. Vērtība: negatīva -> Atgriež kļūdu 'Price must be positive'
BEGIN
    -- Nomaini vērtību šeit, lai pārbaudītu dažādus scenārijus
    update_product_price_dynamic(1, 100);
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Test Failed: ' || SQLERRM);
END;