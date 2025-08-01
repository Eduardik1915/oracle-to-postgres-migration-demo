-- ============================================
-- Testi get_customer_orders procedūrai
-- =====================================
-- Nomainot procedūras pirmā parametra vertības būs dažādas uzvedības.
-- 1. Vērtība: 1 -> Sekmīgi atgriež vērtības
-- 2. Vērtība: 5 -> Atgriež kļūdu 'No orders found for this customer'
-- 3. Vērtība: 6 -> Atgriež kļūdu 'Customer not found'
DO $$
DECLARE
	ref REFCURSOR;
	product_name products.product_name%TYPE;
   quantity orders.quantity%TYPE;
   order_date orders.order_date%TYPE;
BEGIN
    -- Nomaini vērtību šeit, lai pārbaudītu dažādus scenārijus
	call get_customer_orders(1, ref);

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
-- Testi ar pirmo procedūras parametru.
-- 1. Vērtība: 1 -> Sekmīgi nomaina cenu
-- 2. Vērtība: 6 -> Atgriež kļūdu 'No product updated. Possibly invalid ID'
-- Testi ar otro procedūras parametru.
-- 1. Vērtība: pozitīva -> Sekmīgi nomaina cenu
-- 2. Vērtība: negatīva -> Atgriež kļūdu 'Price must be positive'
DO $$
BEGIN
    -- Nomaini vērtību šeit, lai pārbaudītu dažādus scenārijus
    CALL update_product_price_dynamic(1, 100);
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Test Failed: %', SQLERRM;
END;
$$;
