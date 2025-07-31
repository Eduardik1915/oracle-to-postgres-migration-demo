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