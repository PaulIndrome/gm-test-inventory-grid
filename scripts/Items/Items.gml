#macro SHAPE global.item_shapes
global.item_shapes = {
	single : [[0, 0]],
	duo : [[0, 0], [1, 0]],
	corner_short :[ [0, 0], [0, 1], [1, 0] ],
	corner_lop : [[0, 0], [1, 0], [2, 0], [0, 1]],
}

function Item(_shape, _name) constructor {
	shape = _shape;
	name = _name;
	
	///@func get_shape
	static get_shape = function(_rot){
	    var _shape_rot = array_map(shape, method({rot : _rot}, function(_e){
			var _coords = [ _e[0], _e[1] ];
			switch(rot){
			    case ITEM_ROTATIONS.SOUTH:
					_coords = [ -_e[1], _e[0] ];
					break;
			    case ITEM_ROTATIONS.WEST:
					_coords = [ -_e[0], -_e[1] ];
					break;
			    case ITEM_ROTATIONS.NORTH:
					_coords = [ _e[1], -_e[0]];
					break;
				case ITEM_ROTATIONS.EAST: // falls through
				default:
					break;
			}
			return _coords;
		}));
		
		return _shape_rot;
	}
	
	static get_space_num = function(){
	    return array_length(shape);
	}
}

global.items = {
	single : new Item(SHAPE.single, "single"),
	duo : new Item(SHAPE.duo, "duo"), 
	corner_short : new Item(SHAPE.corner_short, "corner short rel"),
	corner_lop : new Item(SHAPE.corner_lop, "corner lop"),
}