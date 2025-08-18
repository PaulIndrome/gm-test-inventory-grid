rebinding_active = false;

rebinding_device = INPUT_NO_DEVICE; // INPUT_KBM for keyboard, 0-3 for gamepad
rebinding_gamepad = false; // convenience variable because we want this value to persist across frames
current_binding = undefined;

///@func set_rebinding
set_rebinding = function(_device, _verb){
	if(rebinding_active) exit; // early return because we only ever want one device rebinding - for now
	
	rebinding_active = true;
	rebinding_device = _device;
	rebinding_gamepad = InputDeviceIsGamepad(rebinding_device);
		
	current_binding = InputBindingGet(rebinding_gamepad, _verb);
	
	// main call to set device to rebinding mode
	// from next step on, it will scan for ANY input without triggering game or menu verbs
	InputDeviceSetRebinding(rebinding_device, true);
}

///@func reset_rebinding
///@desc convenience function to reset all variables to their default
reset_rebinding = function(){
	rebinding_active = false;
	rebinding_device = INPUT_NO_DEVICE;
	rebinding_gamepad = false;
	
	current_binding = undefined;
	
	InputDeviceStopAllRebinding();
}

///@func gamepad_check_any_input
///@desc checks sequentially for any input on numbered gamepad (taken from: https://forum.gamemaker.io/index.php?threads/a-way-to-detect-any-button-pressed-on-the-gamepad.7268/post-619197)
gamepad_check_any_input = function(_pad_num) {
    for ( var i = gp_face1; i <= gp_padr; i++ ) {
        if ( gamepad_button_check( _pad_num, i ) ) return i;
    }
    for ( var i = gp_axislh; i <= gp_axisrv; i++ ) {
        if abs( gamepad_axis_value( _pad_num, i ) ) return i;
    }
	
	return -1;
}