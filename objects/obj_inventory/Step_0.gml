if(is_instanceof(inventory, InventoryGrid) == false) exit;

mouse_pos_x = window_views_mouse_get_x();
mouse_pos_y = window_views_mouse_get_y();


mouse_wheel_scroll();

active_slot_x = floor((mouse_pos_x - gui_pos_x) / inventory.slot_width + scroll_x / inventory.slot_width);
active_slot_y = floor((mouse_pos_y - gui_pos_y) / inventory.slot_height + scroll_y / inventory.slot_height);

active_slot_valid = get_active_slot_valid(active_slot_x, active_slot_y);

if(active_slot_valid == false) exit;

hovered_item = inventory.get_item(active_slot_x, active_slot_y);