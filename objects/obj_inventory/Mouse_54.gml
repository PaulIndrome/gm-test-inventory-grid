// global RMB pressed

if(mouse_active == false) exit;
if(mouse_is_dragging_item == false) exit;
if(is_instanceof(mouse_pressed_item, GridItem) == false) exit;

mouse_pressed_item_rotation = (mouse_pressed_item_rotation + 1) % ITEM_ROTATIONS.LENGTH;

mouse_pressed_item_offset = rotate_offset(mouse_pressed_item_offset);