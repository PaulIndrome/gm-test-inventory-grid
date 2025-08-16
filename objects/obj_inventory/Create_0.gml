randomise();

inventory = new InventoryGrid(columns, rows, 32, 32);

mouse_pos_x = 0;
mouse_pos_y = 0;
mouse_on_inventory = false;
mouse_active = false;
mouse_dragging = false;
mouse_is_dragging_item = false;

mouse_pressed_x = 0;
mouse_pressed_y = 0;
mouse_pressed_slot_x = -1;
mouse_pressed_slot_y = -1;
mouse_pressed_item = undefined;
mouse_pressed_item_offset = [0, 0];
mouse_pressed_item_rotation = ITEM_ROTATIONS.EAST;

mouse_pressed_item_surf = undefined;
mouse_pressed_item_surf_rotation = 0;

inventory_grid_surface = undefined;

active_slot_valid = false;
active_slot_x = -1;
active_slot_y = -1;

scroll_step_x = 16;
scroll_step_y = 16;
scroll_x = 0;
scroll_y = 0;
slots_per_width = gui_width / inventory.slot_width;
slots_per_height = gui_height / inventory.slot_height;
scroll_x_max = inventory.slot_width * inventory.columns - gui_width;
scroll_y_max = inventory.slot_height * inventory.rows - gui_height;

hovered_item = undefined;
hovered_item_to_remove = undefined;
hovered_item_to_remove_clear = time_source_create(time_source_game, 0.25, time_source_units_seconds, method(id, function(){ hovered_item_to_remove = undefined; }));

inventory.add_item(global.items.corner_short, 0, 5, ITEM_ROTATIONS.EAST);
inventory.add_item(global.items.duo, 4, 5, ITEM_ROTATIONS.SOUTH);
inventory.add_item(global.items.single, 8, 5, ITEM_ROTATIONS.WEST);
inventory.add_item(global.items.corner_lop);

///@func is_slot_highlighted
is_slot_highlighted = function(_id_x, _id_y){
	var _value = _id_x == active_slot_x && _id_y == active_slot_y;
	
    return _value;
}

///@func slot_gui_x
slot_gui_x = function(_id_x){
    return _id_x * inventory.slot_width;
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
    return _id_y * inventory.slot_height;
}

///@func get_active_slot_valid
get_active_slot_valid = function(_id_x, _id_y){
	var _val = _id_x < inventory.columns && _id_x > -1 && _id_y < inventory.rows && _id_y > -1;
    return _val;
}

///@func get_mouse_on_inventory
get_mouse_on_inventory = function(_mouse_x, _mouse_y){
	if(global.inventory_panning != noone){
		return global.inventory_panning == id;
	}
	
    return _mouse_x > gui_pos_x && _mouse_y > gui_pos_y && _mouse_x < gui_pos_x + gui_width && _mouse_y < gui_pos_y + gui_height;
}

///@func rotate_offset
///@param {Array<real>} _offset
rotate_offset = function(_offset, _steps = 1){
	if(_steps == 0) return _offset;
    if(_offset[0] == 0 && _offset[1] == 0) return _offset;
	
	var _cw = sign(_steps) > -1;
	repeat(abs(_steps)){
	    // rotating cw is [-y, x], ccw is [y, -x]
		_offset = _cw ? [ -_offset[1], _offset[0] ] : [ _offset[1], -_offset[0] ];
	}
	
	return _offset;
}

///@func mouse_wheel_scroll
mouse_wheel_scroll = function(){
	if(mouse_wheel_up()){
		if(keyboard_check(vk_shift)){
			scroll_x = clamp(scroll_x - scroll_step_x, 0, scroll_x_max);
		} else {
			scroll_y = clamp(scroll_y - scroll_step_y, 0, scroll_y_max);
		}
	}

	if(mouse_wheel_down()){	
		if(keyboard_check(vk_shift)){
			scroll_x = clamp(scroll_x + scroll_step_x, 0, scroll_x_max);
		} else {
			scroll_y = clamp(scroll_y + scroll_step_y, 0, scroll_y_max);
		}
	}
}