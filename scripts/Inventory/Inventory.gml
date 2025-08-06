global.item_dragged = undefined;
global.last_operation_result = undefined;

function ds_grid_foreach(_id_grid, _func, _offset = 0, _length = infinity){
	var _x = 0;
	var _y = 0;
    repeat(ds_grid_width(_id_grid)){
	    repeat(ds_grid_height(_id_grid)){
		    
			_y++;
		}
		_x++;
		_y = 0;
	}
}

function InventoryGrid(_columns = 16, _rows = 16, _slot_width = 16, _slot_height = 16) constructor {
	columns = _columns;
	rows = _rows;
	
	slot_width = _slot_width;
	slot_height = _slot_height;
	
	grid = ds_grid_create(columns, rows);
	grid_items = array_create(0);
	
	///@func add_item
	///@param {Struct.Item} _item
	///@param {real} _x
	///@param {real} _y
	///@param {Constant.ITEM_ROTATIONS} _rot
	static add_item = function(_item, _x = -1, _y = -1, _rot = -1){
		if(_x < 0 || _y < 0){
		    var _first_fit = get_first_fitting_spot(_item, _rot);
			if(_first_fit == false) return ITEM_ERROR.DEST_INVENTORY_FULL;
			
			_x = _first_fit[0];
			_y = _first_fit[1];
			_rot = _first_fit[2];
		}
		
		var _grid_item = new GridItem(_item, _x, _y, _rot);
		
		place_item(_grid_item);
	}
	
	static place_item = function(_grid_item){
	    if(is_instanceof(_grid_item, GridItem) == false) exit;
		
		write_to_occupied_slots(_grid_item);
		
		if(array_contains(grid_items, _grid_item)) exit;
		
		array_push(grid_items, _grid_item);
	}
	
	///@func write_to_occupied_slots
	static write_to_occupied_slots = function(_grid_item, _value = _grid_item){
		if(is_instanceof(_grid_item, GridItem) == false) exit;
		
	    var _o = 0;
		repeat(array_length(_grid_item.occupied_slots)){
			var _coords = _grid_item.occupied_slots[_o++];
		    grid[# _coords[0], _coords[1]] = _value;
			
			occupied[_coords[0]][_coords[1]] = is_instanceof(_value, GridItem) ? true : false;
		}
	}
	
	static get_width = function() { return columns * slot_width; }
	static get_height = function() { return rows * slot_height; }
	
	static is_slot_valid = function(_c, _r) { 
		var _value = _c > -1 && _r > -1 && _c < columns && _r < rows;
		return _value; 
	}
	
	///@func get_item
	static get_item = function(_c, _r) {
	    return is_slot_valid(_c, _r) ? grid[# _c, _r] : undefined;
	}
	
	///@func get_is_slot_occupied
	static get_is_slot_occupied = function(_c, _r) {
	    return is_instanceof(get_item(_c, _r), GridItem);
	}
	
	///@func get_first_fitting_spot
	static get_first_fitting_spot = function(_item, _rot = -1){
		var _x = 0;
		var _y = 0;
		
		if(_rot > -1){
		    var _shape = _item.get_shape(_rot);
			repeat(ds_grid_width(grid)){
			    repeat(ds_grid_height(grid)){
					var _fit = can_fit_position(_shape, _x, _y);
				
					if(_fit){
					    return [_x, _y, _rot];
					}
			
					_y++;
				}
				_x++;
				_y = 0;
			}
		} else {
			repeat(ds_grid_width(grid)){
			    repeat(ds_grid_height(grid)){
					var _fit = false;
					var _shape = [];
					_rot = -1;
					do {
						_rot++;
						_shape = _item.get_shape(_rot);
						_fit = can_fit_position(_shape, _x, _y);
					} until(_rot >= ITEM_ROTATIONS.LENGTH || _fit == true)
					
					if(_fit) return [_x, _y, _rot];
					
					_y++;
				}
				_x++;
				_y = 0;
			}
		}
		
		
		return false;
	}
	
	///@func can_fit_position
	///@param {Array<real>} _shape
	///@param {real} _x
	///@param {real} _y
	///@param {Array<Struct.GridItem>} _ignore_items
	static can_fit_position = function(_shape, _x, _y, _ignore_items = []){
		var _i = 0;
		
		if(is_array(_ignore_items) == false){
		    _ignore_items = [_ignore_items];
		}
		
	    repeat(array_length(_shape)){
			var _spot_x = _x + _shape[_i][0];
			var _spot_y = _y + _shape[_i][1];
			
			if(is_slot_valid(_spot_x, _spot_y) == false) return false;
			
			var _item = get_item(_spot_x, _spot_y);
			// slot is occupied and item in it is not ignored
			if(is_instanceof(_item, GridItem) && array_contains(_ignore_items, _item) == false){
				return false;
			}
			
			_i++;
		}
		
		return true;
	}
	
	///@func move_item
	static move_item = function(_grid_item, _target_x, _target_y, _rot = -1){
		if(is_instanceof(_grid_item, GridItem) == false) exit;
	    
		if(_rot < 0){
		    _rot = _grid_item.rotation;
		}
		
		write_to_occupied_slots(_grid_item, 0);
		
		_grid_item.update_occupied_slots(_target_x, _target_y, _rot);
		
		write_to_occupied_slots(_grid_item);
		
		return ITEM_ERROR.NONE;
	}
	
	///@func replace_item
	static replace_item = function(_replace, _with, _target_x = _replace.slot_x, _target_y = _replace.slot_y){
		if(is_instanceof(_replace, GridItem) == false) exit;
		if(is_instanceof(_with, GridItem) == false) exit;
		
		remove_item(_replace);
		
		_with.update_occupied_slots(_target_x, _target_y);
		
		place_item(_with);
	}
	
	///@func remove_item
	static remove_item = function(_grid_item){
	    if(is_instanceof(_grid_item, GridItem) == false) exit;
		
		write_to_occupied_slots(_grid_item, 0);
		
		var _i = array_find_index(grid_items, method({ grid_item : _grid_item }, function(_e){ return _e == grid_item; }));
		if(_i < 0) exit;
		
		array_delete(grid_items, _i, 1);
	}
	
	///@func check_internal_swap
	///@desc checks if the new positions of the swapped items would collide when in the same inventory
	///@param {Struct.GridItem} _src_item
	///@param {real} _src_x
	///@param {real} _src_y
	///@param {Struct.GridItem} _dest_item
	///@param {real} _dest_x
	///@param {real} _dest_y
	///@param {real} _src_item_rot ITEM_ROTATIONS
	static check_internal_swap = function(_src_item, _src_x, _src_y, _dest_item, _dest_x, _dest_y, _src_item_rot = -1){
	    if(is_instanceof(_src_item, GridItem) == false) exit;
		if(is_instanceof(_dest_item, GridItem) == false) exit;
	
		_src_item_rot = _src_item_rot < 0 ? _src_item.rotation : _src_item_rot;
	
		var _new_occupied_a = _src_item.get_occupied_slots(_dest_x, _dest_y, _src_item_rot);
		var _new_occupied_b = _dest_item.get_occupied_slots(_src_x, _src_y);
			
		var _space_a = _src_item.get_space_num();
		var _space_b = _dest_item.get_space_num();
			
		var _a_outer = _space_a >= _space_b;
		var _outer = _a_outer ? _new_occupied_a : _new_occupied_b;
		var _inner = _a_outer ? _new_occupied_b : _new_occupied_a;
			
		if(array_any(_outer, method({ inner : _inner }, function(_o){
			return array_any(inner, method({o : _o}, function(_i){
				return o[0] == _i[0] && o[1] == _i[1];
			}));
		}))) return ITEM_ERROR.SWAP_CONFLICT;
	
		return ITEM_ERROR.NONE;
	}
}