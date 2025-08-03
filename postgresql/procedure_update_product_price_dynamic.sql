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