-- ============================================
-- Procedure: update_product_price_dynamic
-- Apraksts: atjauno produkta cenu caur dinamisko SQL
-- ============================================
CREATE OR REPLACE PROCEDURE update_product_price_dynamic (
    p_product_id IN products.product_id%TYPE,
    p_new_price IN products.price%TYPE
) AS
    v_sql VARCHAR2(500);
BEGIN
    IF p_new_price <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Price must be positive');
    END IF;

    v_sql := 'UPDATE products SET price = :1 WHERE product_id = :2';

    EXECUTE IMMEDIATE v_sql USING p_new_price, p_product_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'No product updated. Possibly invalid ID.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- logging
        RAISE;
END;