if(mouse_active == false) exit;
if(is_instanceof(mouse_pressed_item, GridItem) == false) exit;

mouse_pressed_item_rotation = (mouse_pressed_item_rotation + 1) % ITEM_ROTATIONS.LENGTH;

rotate_drag_offset();