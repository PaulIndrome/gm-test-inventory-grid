if(is_instanceof(inventory, InventoryGrid) == false) exit;

if(surface_exists(inventory_grid_surface) == false){
	inventory_grid_surface = surface_create(inventory.get_width(), inventory.get_height());
}

var _x = 0;
var _y = 0;

surface_set_target(inventory_grid_surface);
draw_clear_alpha(c_black, 0);

// draw active slot background
if(active_slot_valid){
	draw_set_color( make_color_rgb(20, 20, 20) );
	var _active_x = slot_gui_x(active_slot_x);
	var _active_y = slot_gui_y(active_slot_y);
	
    draw_roundrect_ext(_active_x, _active_y, _active_x + inventory.slot_width, _active_y + inventory.slot_height, 16, 16, false);
}

// draw hovered item background 
// need the instanceof check because returning undefined sets a value in the grid to 0 and that is not undefined -.-
if(active_slot_valid && is_instanceof(hovered_item, GridItem)){
    draw_set_color( make_color_rgb(0, 25, 0) );
	
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
		
		draw_set_color(_col);
	    draw_roundrect_ext(_x, _y, _x + inventory.slot_width, _y + inventory.slot_height, 16, 16, true);
		
		_y += inventory.slot_height;
		_id_y++;
	}
	
	_x += inventory.slot_width;
	_id_x++;
	_id_y = 0;
	_y = 0;
}

//draw items on grid
var _i = 0;
repeat(array_length(inventory.grid_items)){
	draw_set_color(c_lime);
	var _grid_item = inventory.grid_items[_i++];
    var _edges = _grid_item.unique_edges;
	
	draw_set_alpha(0.2);
	_x = slot_gui_x(_grid_item.occupied_slots[0][0]);
	_y = slot_gui_y(_grid_item.occupied_slots[0][1]);
	draw_roundrect_ext(_x, _y, _x + inventory.slot_width, _y + inventory.slot_height, 16, 16, false);
	
	draw_set_alpha(1);
	var _e = 0;
	repeat(array_length(_edges)){
	    var _edge = _edges[_e++];
		
		var _ex1 = _edge.x0 * inventory.slot_width;
		var _ex2 = _edge.x1 * inventory.slot_width + 1;
		var _ey1 = _edge.y0 * inventory.slot_height;
		var _ey2 = _edge.y1 * inventory.slot_height + 1;
		
		draw_line(_ex1, _ey1, _ex2 , _ey2);
	}
}

surface_reset_target();

draw_surface_part(inventory_grid_surface, scroll_x, scroll_y, gui_width, gui_height, gui_pos_x, gui_pos_y);

draw_set_color(c_white);


// draw dragged item
if(mouse_dragging && is_instanceof(mouse_pressed_item, GridItem)){
	if(surface_exists(mouse_pressed_item_surf) == false){ // create dragging surface
		mouse_pressed_item_surf = surface_create(window_get_width(), window_get_height());
	
		surface_set_target(mouse_pressed_item_surf);
		draw_clear_alpha(c_black, 0.0);
	
		draw_set_color(c_white);
		var _shape_east = mouse_pressed_item.item.get_shape();
		var _offset_east = rotate_offset([mouse_pressed_item_offset[0], mouse_pressed_item_offset[1]], - mouse_pressed_item_rotation);
	
		var _i = 0;
		repeat(array_length(_shape_east)){
			var _coords = _shape_east[_i++];
		
			_x = mouse_pressed_x - inventory.slot_width * 0.5 + (_coords[0] - _offset_east[0]) * inventory.slot_width;
			_y = mouse_pressed_y - inventory.slot_height * 0.5 + (_coords[1] - _offset_east[1]) * inventory.slot_height;
		
			draw_roundrect_ext(_x, _y, _x + inventory.slot_width, _y + inventory.slot_height, 16, 16, false);
		}
	
		surface_reset_target();
	
		draw_set_color(c_white);
	}
	
	var _rot = mouse_pressed_item_rotation * 90; // converting from EAST == 0 in cw rotation to degrees
	
	mouse_pressed_item_surf_rotation -= angle_difference(mouse_pressed_item_surf_rotation, _rot) * 0.2;
	mouse_pressed_item_surf_rotation %= 360;
	
	// determine mouse position delta to initial position when the surface was drawn
	var _mouse_dx = mouse_pos_x - mouse_pressed_x;
	var _mouse_dy = mouse_pos_y - mouse_pressed_y;
	
	// offset to surface origin (0|0)
	var _tx = - mouse_pos_x + _mouse_dx;
	var _ty = - mouse_pos_y + _mouse_dy;
	
	// rotate surface origin around the offset
	var _rot_x = _tx * dcos(mouse_pressed_item_surf_rotation) - _ty * dsin(mouse_pressed_item_surf_rotation);
	var _rot_y = _tx * dsin(mouse_pressed_item_surf_rotation) + _ty * dcos(mouse_pressed_item_surf_rotation);
	
	// draw surface at mouse position
	draw_surface_ext(mouse_pressed_item_surf, mouse_pos_x + _rot_x, mouse_pos_y + _rot_y, 1, 1, - mouse_pressed_item_surf_rotation, c_white, 0.1);
	
	#region unused immediate rotation using draw directly
	//draw_set_color(c_blue);
	//draw_set_alpha(0.5);
	//var _rot = mouse_pressed_item_rotation;
	//var _shape = mouse_pressed_item.item.get_shape(_rot);
	
	//var _i = 0;
	//repeat(array_length(_shape)){
	//	var _coords = _shape[_i++];
		
	//	_x = mouse_pos_x - inventory.slot_width * 0.5 + (_coords[0] - mouse_pressed_item_offset[0]) * inventory.slot_width;
	//	_y = mouse_pos_y - inventory.slot_height * 0.5 + (_coords[1] - mouse_pressed_item_offset[1]) * inventory.slot_height;
		
	//    draw_roundrect_ext(_x, _y, _x + inventory.slot_width, _y + inventory.slot_height, 16, 16, false);
	//}
	//draw_set_alpha(1.0);
	#endregion
}

draw_set_color(c_white);

if(active_slot_valid == false) exit;

_y = inventory.rows * inventory.slot_height + gui_pos_y;
draw_text(0, _y, $"slot: {active_slot_x} | {active_slot_y}")

draw_text(0, _y + 16, $"last op error: {ITEM_ERROR_STRING(global.last_operation_result)}");

draw_set_halign(fa_right);
draw_text(display_get_gui_width(), _y, $"LMB drag: drag items");
draw_text(display_get_gui_width(), _y + 16, $"RMB while dragging: rotate dragged item");

draw_set_halign(fa_left);
