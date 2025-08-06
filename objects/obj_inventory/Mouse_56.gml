if(mouse_active == false) exit;

// dragged an item to another slot
if(mouse_is_dragging_item){
	var _shape_dragged = mouse_pressed_item.get_shape(mouse_pressed_item_rotation);
	
	var _dest_inventory = inventory;
	var _dest_item = hovered_item;
	var _dest_target_x = active_slot_x;
	var _dest_target_y = active_slot_y;
	var _dest_slot_x = active_slot_x - mouse_pressed_item_offset[0];
	var _dest_slot_y = active_slot_y - mouse_pressed_item_offset[1];
	
	with(obj_inventory){
		if(id == other) continue;
		
	    if(active_slot_valid){
		    _dest_inventory = inventory;
			_dest_item = hovered_item;
			_dest_target_x = active_slot_x;
			_dest_target_y = active_slot_y;
			_dest_slot_x = active_slot_x - other.mouse_pressed_item_offset[0];
			_dest_slot_y = active_slot_y - other.mouse_pressed_item_offset[1];
		}
	}
	
	// dragged item over a different item
	if(is_instanceof(_dest_item, GridItem) && _dest_item != mouse_pressed_item){
		var _dest_item_offset_to_source = _dest_item.get_drag_offset(_dest_target_x, _dest_target_y);
		var _src_slot_x = mouse_pressed_slot_x - _dest_item_offset_to_source[0];
		var _src_slot_y = mouse_pressed_slot_y - _dest_item_offset_to_source[1];
		
		global.last_operation_result = inventory_try_swap_items(inventory, mouse_pressed_item, _dest_inventory, _dest_item, _src_slot_x, _src_slot_y, _dest_slot_x, _dest_slot_y, mouse_pressed_item_rotation);
	} else { // dragged item to an empty slot or different slot on itself
		var _dest_fit = _dest_inventory.can_fit_position(_shape_dragged, _dest_slot_x, _dest_slot_y, mouse_pressed_item);
		
		if(_dest_fit){
			if(_dest_inventory == inventory){
			    global.last_operation_result = inventory.move_item(mouse_pressed_item, _dest_slot_x, _dest_slot_y, mouse_pressed_item_rotation);
			} else {
			    inventory.remove_item(mouse_pressed_item);
				mouse_pressed_item.update_occupied_slots(_dest_slot_x, _dest_slot_y, mouse_pressed_item_rotation);
				
				_dest_inventory.place_item(mouse_pressed_item);
			}
		} else {
		    global.last_operation_result = ITEM_ERROR.DEST_FIT;
		}
	}
}

mouse_pressed_x = 0;
mouse_pressed_y = 0;
mouse_pressed_slot_x = -1;
mouse_pressed_slot_y = -1;

mouse_active = false;
mouse_dragging = false;
mouse_is_dragging_item = false;
mouse_pressed_item_rotation = 0;
mouse_pressed_item_offset = [];

mouse_pressed_item = undefined;
surface_free(mouse_pressed_item_surf);