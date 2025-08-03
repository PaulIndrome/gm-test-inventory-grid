mouse_active = get_was_clicked(mouse_pos_x, mouse_pos_y);
//show_debug_message($"pressed");

mouse_pressed_slot_x = active_slot_x;
mouse_pressed_slot_y = active_slot_y;

mouse_pressed_item = inventory.get_item(mouse_pressed_slot_x, mouse_pressed_slot_y);
mouse_pressed_item_rotation = is_instanceof(mouse_pressed_item, GridItem) ? mouse_pressed_item.rotation : ITEM_ROTATIONS.EAST;