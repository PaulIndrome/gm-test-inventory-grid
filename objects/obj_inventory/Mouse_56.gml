if(mouse_active == false) exit;
//show_debug_message($"released");
alarm[0] = -1;

// dragged an item to another slot
if(mouse_dragging && (active_slot_x != mouse_pressed_slot_x || active_slot_y != mouse_pressed_slot_y) && is_instanceof(mouse_pressed_on_item, GridItem)){
	var _shape_dragged = mouse_pressed_on_item.get_shape();
	
	// dragged item over a different item
	if(is_instanceof(hovered_item, GridItem) && hovered_item != mouse_pressed_on_item){
	    
		var _shape_active = hovered_item.get_shape();
		
		var _dest_fit = inventory.can_fit_position(_shape_dragged, active_slot_x, active_slot_y, hovered_item);
		var _source_fit = inventory.can_fit_position(_shape_active, mouse_pressed_slot_x, mouse_pressed_slot_y, mouse_pressed_on_item);
		
		if(_dest_fit && _source_fit){
		    inventory.swap_items(mouse_pressed_on_item, hovered_item, active_slot_x, active_slot_y);
		}
	} else { // dragged item to a different slot on itself
		var _dest_fit = inventory.can_fit_position(_shape_dragged, active_slot_x, active_slot_y, mouse_pressed_on_item);
		
		if(_dest_fit){
		    inventory.move_item(mouse_pressed_on_item, active_slot_x, active_slot_y);
		}
	}
}

mouse_pressed_slot_x = -1;
mouse_pressed_slot_y = -1;

mouse_active = false;
mouse_dragging = false;

mouse_pressed_on_item = undefined;