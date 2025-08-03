-- ============================================
-- Function: get_customer_order_summary
-- Apraksts: atgriež klienta pasūtījumus
-- =====================================
CREATE OR REPLACE FUNCTION get_customer_order_summary (
    p_customer_id customers.customer_id%TYPE
) RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
	c_orders CURSOR FOR
        SELECT o.order_id, p.product_name, p.price
        FROM orders o
        JOIN products p ON o.product_id = p.product_id
        WHERE o.customer_id = p_customer_id;

    v_summary VARCHAR(4000) := '';
BEGIN
	FOR r IN c_orders LOOP
        v_summary := v_summary || 'Order #' || r.order_id || 
                     E': ' || r.product_name || 
                      ' ($' || TO_CHAR(r.price, '9990.00') || ')' || E'\n';
    END LOOP;

	IF v_summary = '' THEN
        RETURN 'No orders found.';
    ELSE
        RETURN v_summary;
    END IF;
END;
$$;