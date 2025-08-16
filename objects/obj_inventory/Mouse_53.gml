// global LMB pressed

mouse_active = mouse_on_inventory;

if(mouse_active == false) exit;

mouse_pressed_x = mouse_pos_x;
mouse_pressed_y = mouse_pos_y;

mouse_pressed_slot_x = active_slot_x;
mouse_pressed_slot_y = active_slot_y;

mouse_pressed_item = inventory.get_item(mouse_pressed_slot_x, mouse_pressed_slot_y);
mouse_pressed_item_offset = is_instanceof(mouse_pressed_item, GridItem) ? mouse_pressed_item.get_drag_offset(mouse_pressed_slot_x, mouse_pressed_slot_y) : [0, 0];
mouse_pressed_item_rotation = is_instanceof(mouse_pressed_item, GridItem) ? mouse_pressed_item.rotation : ITEM_ROTATIONS.EAST;
mouse_pressed_item_surf_rotation = mouse_pressed_item_rotation * 90;