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
/
