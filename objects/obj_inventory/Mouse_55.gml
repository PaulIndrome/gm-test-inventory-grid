mouse_active = mouse_on_inventory;

if(mouse_active == false) exit;

mouse_pressed_x = mouse_pos_x;
mouse_pressed_y = mouse_pos_y;

mouse_pressed_slot_x = active_slot_x;
mouse_pressed_slot_y = active_slot_y;

global.inventory_panning = id;

if(is_instanceof(hovered_item, GridItem)){
	hovered_item_to_remove = hovered_item;

	time_source_start(hovered_item_to_remove_clear);
}

window_set_cursor(cr_none);