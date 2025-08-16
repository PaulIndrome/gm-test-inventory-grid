if(global.inventory_panning != id) exit;

if(mouse_active == false) exit;

if(mouse_dragging && hovered_item_to_remove == hovered_item){
	inventory.remove_item(hovered_item);
}

global.inventory_panning = noone;

window_set_cursor(cr_default);
window_mouse_set(mouse_pressed_x, mouse_pressed_y);

mouse_pressed_x = 0;
mouse_pressed_y = 0;
mouse_pressed_slot_x = -1;
mouse_pressed_slot_y = -1;

mouse_active = false;
mouse_dragging = false;

hovered_item_to_remove = undefined;