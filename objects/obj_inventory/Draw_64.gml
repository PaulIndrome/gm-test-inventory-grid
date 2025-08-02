if(is_instanceof(inventory, InventoryGrid) == false) exit;

var _x = gui_pos_x;
var _y = gui_pos_y;

// draw active slot background
if(active_slot_valid){
	draw_set_color( make_color_rgb(20, 20, 20) );
	var _active_x = slot_gui_x(active_slot_x);
	var _active_y = slot_gui_y(active_slot_y);
	
    draw_roundrect_ext(_active_x, _active_y, _active_x + inventory.slot_width, _active_y + inventory.slot_height, 16, 16, false);
}

//  draw hovered item background 
// need the instanceof check because returning undefined sets a value to 0 and that is not undefined -.-
if(active_slot_valid && is_instanceof(hovered_item, GridItem)){
    draw_set_color( make_color_rgb(125, 0, 0) );
	
	var _occupied = hovered_item.occupied_slots;
	var _o = 0;
	
	repeat(array_length(_occupied)){
		var _gui_x = slot_gui_x(_occupied[_o][0]);
		var _gui_y = slot_gui_y(_occupied[_o][1]);
		draw_roundrect_ext(_gui_x, _gui_y, _gui_x + inventory.slot_width, _gui_y + inventory.slot_height, 16, 16, false);
	
		_o++;
	}
}

// draw grid
draw_set_color(c_dkgray);

var _id_x = 0;
var _id_y = 0;

repeat(inventory.columns){
    repeat(inventory.rows){
		var _col = is_slot_highlighted(_id_x, _id_y) ? c_gray : c_dkgray;
		_col = inventory.get_is_slot_occupied(_id_x, _id_y) ? c_red : _col;
		
		draw_set_color(_col);
	    draw_roundrect_ext(_x, _y, _x + inventory.slot_width, _y + inventory.slot_height, 16, 16, true);
		
		_y += inventory.slot_height;
		_id_y++;
	}
	
	_x += inventory.slot_width;
	_id_x++;
	_id_y = 0;
	_y = gui_pos_y;
}

draw_set_color(c_white);

// draw drag line
if(active_slot_valid && mouse_active){
    var _start_x = slot_gui_center_x(mouse_pressed_slot_x);
	var _start_y = slot_gui_center_y(mouse_pressed_slot_y);
	var _end_x = slot_gui_center_x(active_slot_x);
	var _end_y = slot_gui_center_y(active_slot_y);
	draw_line(_start_x, _start_y, _end_x, _end_y);
}

if(active_slot_valid && mouse_dragging){
	draw_set_color(c_blue);
	
	var _rot = mouse_pressed_on_item.rotation;
    var _shape = mouse_pressed_on_item.item.get_shape(_rot);
	
	var _i = 0;
	repeat(array_length(_shape)){
		var _coords = _shape[_i++];
		
		_x = mouse_pos_x + _coords[0] * inventory.slot_width;
		_y = mouse_pos_y + _coords[1] * inventory.slot_height;
		
	    draw_roundrect_ext(_x, _y, _x + inventory.slot_width, _y + inventory.slot_height, 16, 16, false);
	}
}

draw_set_color(c_white);

_y = inventory.rows * inventory.slot_height + gui_pos_y;
draw_text(0, _y, $"slot: {active_slot_x} | {active_slot_y}")

