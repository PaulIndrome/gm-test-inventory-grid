randomise();

inventory = new InventoryGrid(16, 8, 32, 32);

mouse_pos_x = 0;
mouse_pos_y = 0;
mouse_active = false;
mouse_dragging = false;
mouse_dragging_item = false;

mouse_pressed_slot_x = -1;
mouse_pressed_slot_y = -1;
mouse_pressed_item = undefined;
mouse_pressed_item_rotation = ITEM_ROTATIONS.EAST;

active_slot_valid = false;
active_slot_x = -1;
active_slot_y = -1;

hovered_item = undefined;

draw_highlight = false;

inventory.add_item(global.items.corner_short, 0, 5, ITEM_ROTATIONS.EAST);
inventory.add_item(global.items.duo, 4, 5, ITEM_ROTATIONS.SOUTH);
inventory.add_item(global.items.single, 8, 5, ITEM_ROTATIONS.WEST);
inventory.add_item(global.items.corner_lop, 12, 5, ITEM_ROTATIONS.NORTH);

///@func is_slot_highlighted
is_slot_highlighted = function(_id_x, _id_y){
	var _value = _id_x == active_slot_x && _id_y == active_slot_y;
	
    return _value;
}

///@func slot_gui_x
slot_gui_x = function(_id_x){
    return _id_x * inventory.slot_width + gui_pos_x;
}

///@func slot_gui_center_x
slot_gui_center_x = function(_id_x){
    return slot_gui_x(_id_x) + inventory.slot_width * 0.5;
}

///@func slot_gui_center_y
slot_gui_center_y = function(_id_y){
    return slot_gui_y(_id_y) + inventory.slot_height * 0.5;
}

///@func slot_gui_y
slot_gui_y = function(_id_y){
    return _id_y * inventory.slot_height + gui_pos_y;
}

///@func get_active_slot_valid
get_active_slot_valid = function(_id_x, _id_y){
	var _val = _id_x < inventory.columns && _id_x > -1 && _id_y < inventory.rows && _id_y > -1;
    return _val;
}

///@func get_was_clicked
get_was_clicked = function(_mouse_x, _mouse_y){
    return _mouse_x > gui_pos_x && _mouse_y > gui_pos_y && _mouse_x < gui_pos_x + inventory.get_width() && _mouse_y < gui_pos_y + inventory.get_height();
}