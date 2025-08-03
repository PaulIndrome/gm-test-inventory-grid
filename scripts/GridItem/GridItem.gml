///@func GridItem
///@param {Struct.Item} _item
///@param {real} _x
///@param {real} _y
///@param {real} _rot
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
	
	///@param {real} _rot
	///@param {Array<real>} _offset
	static get_shape = function(_rot = -1){
		_rot = _rot < 0 ? rotation : _rot;
		
	    return item.get_shape(_rot);
	}
	
	static get_space_num = function(){
	    return item.get_space_num();
	}
	
	///@func get_occupied_slots
	///@desc returns an array of slots this item's shape would occupy at the given coordinates with the given rotation
	///@return Array<>
	static get_occupied_slots = function(_x = -1, _y = -1, _rot = -1){
		_x = _x < 0 ? slot_x : _x;
		_y = _y < 0 ? slot_y : _y;
		_rot = _rot < 0 ? rotation : _rot;
		
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