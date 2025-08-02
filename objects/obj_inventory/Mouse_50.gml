if(mouse_active == false) exit;

//if(alarm[0] < 0){
//    alarm[0] = 30;
//}

mouse_dragging = active_slot_x != mouse_pressed_slot_x || active_slot_y != mouse_pressed_slot_y && is_instanceof(mouse_pressed_on_item, GridItem);