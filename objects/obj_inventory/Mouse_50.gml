// global LMB down

if(mouse_active == false) exit;

var _dragging_item =  is_instanceof(mouse_pressed_item, GridItem);
var _changed_slot = active_slot_x != mouse_pressed_slot_x || active_slot_y != mouse_pressed_slot_y || mouse_on_inventory == false;
var _changed_rotation = _dragging_item && mouse_pressed_item_rotation != mouse_pressed_item.rotation;

mouse_dragging = _changed_slot || _changed_rotation;

mouse_is_dragging_item = mouse_dragging && _dragging_item;