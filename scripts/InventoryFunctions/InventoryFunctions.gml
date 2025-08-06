///@func inventory_try_swap_items
///@param {Struct.InventoryGrid} _src
///@param {Struct.GridItem} _src_item
///@param {Struct.InventoryGrid} _dest
///@param {Struct.GridItem} _dest_item
///@param {real} _src_x
///@param {real} _src_y
///@param {real} _dest_x
///@param {real} _dest_y
///@param {real} _src_rot
function inventory_try_swap_items(_src, _src_item, _dest, _dest_item, _src_x = _src_item.slot_x, _src_y = _src_item.slot_y, _dest_x = _dest_item.slot_x, _dest_y = _dest_item.slot_y, _src_rot = -1){
	var _ignore = [_src_item, _dest_item];
	
	_src_rot = _src_rot < 0 ? _src_item.rotation : _src_rot;
	
	var _src_item_shape = _src_item.get_shape(_src_rot);
	var _dest_item_shape = _dest_item.get_shape();
	
	var _dest_fit = _dest.can_fit_position(_src_item_shape, _dest_x, _dest_y, _ignore);
	var _src_fit = _src.can_fit_position(_dest_item_shape, _src_x, _src_y, _ignore);
	
	if(_dest_fit&& _src_fit){
		if(_src == _dest && _src.check_internal_swap(_src_item, _src_x, _src_y, _dest_item, _dest_x, _dest_y, _src_rot) != ITEM_ERROR.NONE) return ITEM_ERROR.SWAP_CONFLICT;
		
		_src.remove_item(_src_item);
		_dest.remove_item(_dest_item);
		
		_dest_item.update_occupied_slots(_src_x, _src_y);
		_src_item.update_occupied_slots(_dest_x, _dest_y, _src_rot);
		
	    _src.place_item(_dest_item);
		_dest.place_item(_src_item);
		return ITEM_ERROR.NONE;
	}

	if(_dest_fit == _src_fit){
	    return ITEM_ERROR.SWAP_BOTH_FIT;
	}
	
	return _dest_fit ? ITEM_ERROR.SWAP_SRC_FIT : ITEM_ERROR.SWAP_DEST_FIT;
}