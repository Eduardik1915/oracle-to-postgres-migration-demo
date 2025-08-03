-- ============================================
-- Function: get_customer_order_summary
-- Apraksts: atgriež klienta pasūtījumus
-- =====================================
CREATE OR REPLACE FUNCTION get_customer_order_summary (
    p_customer_id IN customers.customer_id%TYPE
) RETURN VARCHAR2
IS
    CURSOR c_orders IS
        SELECT o.order_id, p.product_name, p.price
        FROM orders o
        JOIN products p ON o.product_id = p.product_id
        WHERE o.customer_id = p_customer_id;

    v_summary VARCHAR2(4000) := '';
BEGIN
    FOR r IN c_orders LOOP
        v_summary := v_summary || 'Order #' || r.order_id || 
                     ': ' || r.product_name || 
                     ' ($' || TO_CHAR(r.price, '9990.00') || ')' || CHR(10);
    END LOOP;

    IF v_summary IS NULL THEN
        RETURN 'No orders found.';
    ELSE
        RETURN v_summary;
    END IF;
END;