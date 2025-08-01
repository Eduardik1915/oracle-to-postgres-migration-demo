-- ============================================
-- Procedure: get_customer_orders
-- Apraksts: atgriež klienta pasūtījumus caur OUT-kursoru
-- =====================================
CREATE OR REPLACE PROCEDURE get_customer_orders (
    p_customer_id customers.customer_id%TYPE,
    OUT p_orders REFCURSOR
) 
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists NUMERIC;
BEGIN
	IF NOT EXISTS(
		SELECT 1 FROM customers WHERE customer_id = p_customer_id
	) THEN
		RAISE EXCEPTION 'Customer not found' USING ERRCODE = 'P0001';
	END IF;

	IF NOT EXISTS(
		SELECT 1 FROM orders WHERE customer_id = p_customer_id
	) THEN
		RAISE EXCEPTION 'No orders found for this customer' USING ERRCODE = 'P0002';
	END IF;

	OPEN p_orders FOR
        SELECT p.product_name, o.quantity, o.order_date
        FROM orders o
        JOIN products p ON o.product_id = p.product_id
        WHERE o.customer_id = p_customer_id
        ORDER BY o.order_date DESC;
		
EXCEPTION
	WHEN OTHERS THEN
	--logging
	RAISE;
END;
$$;


-- ============================================
-- Procedure: update_product_price_dynamic
-- Apraksts: atjauno produkta cenu caur dinamisko SQL
-- ============================================
CREATE OR REPLACE PROCEDURE update_product_price_dynamic (
    p_product_id products.product_id%TYPE,
    p_new_price products.price%TYPE
) 
LANGUAGE plpgsql
AS $$
DECLARE
	v_sql VARCHAR(500);
	v_count NUMERIC;
BEGIN
	IF p_new_price <= 0 THEN
        RAISE EXCEPTION 'Price must be positive' USING ERRCODE = 'P0003';
    END IF;

	v_sql := 'UPDATE products SET price = $1 WHERE product_id = $2';

	EXECUTE v_sql USING p_new_price, p_product_id;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	IF v_count = 0 THEN
        RAISE EXCEPTION 'No product updated. Possibly invalid ID.' USING ERRCODE = 'P0004';
    END IF;
	
EXCEPTION
    WHEN OTHERS THEN
        -- logging
        RAISE;
END;
$$;