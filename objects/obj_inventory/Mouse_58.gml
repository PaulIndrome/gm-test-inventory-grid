// global MMB released

if(global.inventory_panning != id) exit;

if(mouse_active == false) exit;

if(mouse_dragging == false && hovered_item_to_remove == hovered_item){
	inventory.remove_item(hovered_item);
}

global.inventory_panning = noone;

window_set_cursor(cr_default);
window_mouse_set(mouse_pressed_x, mouse_pressed_y);

on_mouse_release();