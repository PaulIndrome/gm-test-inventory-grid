global.item_dragged = undefined;

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

enum ITEM_ROTATIONS {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

enum ITEM_REASON {
	DEFAULT, 
	QUEST_ADD_REWARD,
	QUEST_ADD_ITEM,
	QUEST_REMOVE_ITEM,
	DEATH_PENALTY,
}

enum ITEM_ERROR {
	DEST_INVENTORY_FULL,
	AMOUNT_INSUFFICIENT,
}

function GridItem(_item, _x, _y, _rot) constructor {
	item = _item;
	
	slot_x = _x;
	slot_y = _y;
	rotation = _rot;
	
	occupied_slots = get_occupied_slots(slot_x, slot_y, rotation);
	
	///@func update_occupied_slots
	static update_occupied_slots = function(_x = -1, _y = -1, _rot = -1){
		slot_x = _x < 0 ? slot_x : _x;
		slot_y = _y < 0 ? slot_y : _y;
		rotation = _rot < 0 ? rotation : _rot;
		
	    occupied_slots = get_occupied_slots(slot_x, slot_y, rotation);
	}
	
	static get_shape = function(){
	    return item.get_shape(rotation);
	}
	
	///@func get_occupied_slots
	static get_occupied_slots = function(_x, _y, _rot){
	    var _occupation = item.get_shape(_rot);
		
		var _i = 0;
		repeat(array_length(_occupation)){
		    _occupation[_i][0] = _x + _occupation[_i][0];
			_occupation[_i][1] = _y + _occupation[_i][1];
			_i++;
		}
		
		return _occupation;
	}
}

function InventoryGrid(_columns = 16, _rows = 16, _slot_width = 16, _slot_height = 16) constructor {
	columns = _columns;
	rows = _rows;
	
	slot_width = _slot_width;
	slot_height = _slot_height;
	
	grid = ds_grid_create(columns, rows);
	occupied = array_create_ext(columns, function(_i) { return array_create(rows, 0); });
	grid_items = array_create(0);
	
	///@func add_item
	///@param {Struct.Item} _item
	///@param {real} _x
	///@param {real} _y
	///@param {Constant.ITEM_ROTATIONS} _rot
	static add_item = function(_item, _x = -1, _y = -1, _rot = 0){
	    var _shape = _item.get_shape(_rot);
		
		if(_x < 0 || _y < 0){
		    var _first_fit = get_first_fitting_spot(_item, _rot);
			if(_first_fit == false) return ITEM_ERROR.DEST_INVENTORY_FULL;
			
			_x = _first_fit[0];
			_y = _first_fit[1];
		}
		
		var _grid_item = new GridItem(_item, _x, _y, _rot);
		
		__write_to_occupied_slots(_grid_item);
	}
	
	///@func __write_to_occupied_slots
	static __write_to_occupied_slots = function(_grid_item, _value = _grid_item){
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
	static is_slot_valid = function(_c, _r) { return _c > -1 && _r > -1 && _c < columns && _r < rows; }
	
	///@func get_item
	static get_item = function(_c, _r) {
	    return is_slot_valid(_c, _r) ? grid[# _c, _r] : undefined;
	}
	
	///@func get_is_slot_occupied
	static get_is_slot_occupied = function(_c, _r) {
		return occupied[_c][_r];
	    //return is_slot_valid(_c, _r) ? is_instanceof(get_item(_c, _r), GridItem) : true;
	}
	
	///@func get_first_fitting_spot
	static get_first_fitting_spot = function(_item, _rot){
		var _x = 0;
		var _y = 0;
		
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
		
		__write_to_occupied_slots(_grid_item, 0);
		
		_grid_item.update_occupied_slots(_target_x, _target_y, _rot);
		
		__write_to_occupied_slots(_grid_item);
	}
	
	static swap_items = function(_grid_item_a, _grid_item_b, _target_x, _target_y){
		var _a_x = _grid_item_a.slot_x;
		var _a_y = _grid_item_a.slot_y;
		
		__write_to_occupied_slots(_grid_item_a, 0);
		
		__write_to_occupied_slots(_grid_item_b, 0);
		
		_grid_item_a.update_occupied_slots(_target_x, _target_y);
		__write_to_occupied_slots(_grid_item_a);
		
		_grid_item_b.update_occupied_slots(_a_x, _a_y);
		__write_to_occupied_slots(_grid_item_b);
	}
}