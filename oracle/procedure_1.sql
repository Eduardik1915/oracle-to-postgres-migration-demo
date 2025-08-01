-- ============================================
-- Procedure: get_customer_orders
-- Apraksts: atgriež klienta pasūtījumus caur OUT-kursoru
-- =====================================
CREATE OR REPLACE PROCEDURE get_customer_orders (
    p_customer_id IN customers.customer_id%TYPE,
    p_orders OUT SYS_REFCURSOR
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM customers
    WHERE customer_id = p_customer_id;

    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer not found');
    END IF;

    SELECT COUNT(*) INTO v_exists
    FROM orders
    WHERE customer_id = p_customer_id;

    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No orders found for this customer');
    END IF;

    OPEN p_orders FOR
        SELECT p.product_name, o.quantity, o.order_date
        FROM orders o
        JOIN products p ON o.product_id = p.product_id
        WHERE o.customer_id = p_customer_id
        ORDER BY o.order_date DESC;

EXCEPTION
    WHEN OTHERS THEN
        -- logging
        RAISE; 
END;


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