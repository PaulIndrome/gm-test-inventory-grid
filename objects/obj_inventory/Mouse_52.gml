if(global.inventory_panning != id) exit;

if(mouse_active == false && mouse_on_inventory == false) exit;

var _mouse_delta_x = window_mouse_get_delta_x();
var _mouse_delta_y = window_mouse_get_delta_y();

mouse_dragging = mouse_dragging || abs(_mouse_delta_x) + abs(_mouse_delta_y) > 1;

if(mouse_dragging == false) exit;

scroll_x = clamp(scroll_x - _mouse_delta_x, 0, scroll_x_max);
scroll_y = clamp(scroll_y - _mouse_delta_y, 0, scroll_y_max);