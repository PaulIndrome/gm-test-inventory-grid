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
	unique_edges = get_unique_edges();

	///@func update_occupied_slots
	static update_occupied_slots = function(_x = -1, _y = -1, _rot = -1){
		if(slot_x == _x && slot_y == _y && rotation == _rot) exit;
		
		slot_x = _x < 0 ? slot_x : _x;
		slot_y = _y < 0 ? slot_y : _y;
		rotation = _rot < 0 ? rotation : _rot;
		
	    occupied_slots = get_occupied_slots(slot_x, slot_y, rotation);
		unique_edges = get_unique_edges();
	}
	
	static get_drag_offset = function(_x, _y){
	    return [_x - slot_x, _y - slot_y];
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
	
	///@func get_unique_edges
	static get_unique_edges = function(_x = -1, _y = -1, _rot = -1){
	    var _occupation = _x < 0 && _y < 0 && _rot < 0 ? occupied_slots : get_occupied_slots(_x, _y, _rot);
		
		var _edges = array_create(0);
		var _s = 0;
		repeat(array_length(_occupation)){
			var _slot = _occupation[_s++];
			
			var _x0 = _slot[0];
			var _y0 = _slot[1];
			var _x1 = _x0 + 1;
			var _y1 = _y0 + 1;
			
			var _slot_edge_h1 = new GridItemEdge(_x0, _y0, _x1, _y0);
			var _slot_edge_h2 = new GridItemEdge(_x0, _y1, _x1, _y1);
			var _slot_edge_v1 = new GridItemEdge(_x0, _y0, _x0, _y1);
			var _slot_edge_v2 = new GridItemEdge(_x1, _y0, _x1, _y1);
			
			var _slot_edges = [_slot_edge_h1, _slot_edge_h2, _slot_edge_v1, _slot_edge_v2];
			
			_edges = array_concat(_edges, _slot_edges);
		}
		
		static find_edge = function(_edge, _i) { return edge.equals(_edge); }
		
		var _e = 0;
		var _remove = [];
		var _len = array_length(_edges);
		repeat(_len){
			var _edge = _edges[_e];
			
			var _e_found = undefined;
			
			if(_e > 0) {// traverse backwards
				_e_found = _e - 1;
				
				while(_e_found > -1){
					_e_found = array_find_index(_edges, method({ edge : _edge }, find_edge), _e_found, -infinity);
				
					if(_e_found > -1){
					    array_push(_remove, _e_found);
						_e_found--;
					}
				}
			}			
			
			if(_e < _len - 1){ // traverse forwards
				_e_found = _e + 1;
				
				while(_e_found > -1 && _e_found < _len){
					_e_found = array_find_index(_edges, method({ edge : _edge }, find_edge), _e_found, infinity);
				
					if(_e_found > -1){
					    array_push(_remove, _e_found);
						_e_found++;
					}
				}
			}
			
			_e++;
		}

		array_sort(_remove, true);
		
		array_foreach(_remove, method({ edges : _edges }, function(_e, _i){ array_delete(edges, _e, 1); }), -1, -infinity);
		
		return _edges;
	}
}

function GridItemEdge(_x0, _y0, _x1, _y1) constructor {
    x0 = _x0;
	y0 = _y0;
	x1 = _x1;
	y1 = _y1;
	
	static equals = function(_edge){
	    return _edge.x0 == x0 && _edge.y0 == y0 && _edge.x1 == x1 && _edge.y1 == y1;
	}
}