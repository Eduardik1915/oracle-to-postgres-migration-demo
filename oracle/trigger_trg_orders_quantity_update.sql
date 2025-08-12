-- ============================================
-- Trigger: trg_orders_quantity_update
-- Apraksts: saglabā kolonnas orders.quantity izmaiņas old_quantity_log tabulā
-- =====================================
CREATE OR REPLACE TRIGGER trg_orders_quantity_update
BEFORE UPDATE OF quantity ON orders
FOR EACH ROW
BEGIN
    IF :OLD.quantity != :NEW.quantity THEN
        INSERT INTO old_quantity_log (order_id, old_quantity, new_quantity, changed_on)
        VALUES (:OLD.order_id, :OLD.quantity, :NEW.quantity, SYSDATE);
    END IF;
END;