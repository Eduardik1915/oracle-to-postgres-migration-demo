-- ============================================
-- Trigger: trg_orders_quantity_update
-- Apraksts: saglabā kolonnas orders.quantity izmaiņas old_quantity_log tabulā
-- =====================================
create or replace function trg_func_orders_quantity_update()
returns trigger
language plpgsql
as $$
begin
	if old.quantity != new.quantity then
		INSERT INTO old_quantity_log (order_id, old_quantity, new_quantity, changed_on)
        VALUES (OLD.order_id, OLD.quantity, NEW.quantity, LOCALTIMESTAMP);
	end if;
	return new;
end;
$$;

create trigger trg_orders_quantity_update
BEFORE UPDATE OF quantity ON orders
FOR EACH ROW
execute function trg_func_orders_quantity_update();