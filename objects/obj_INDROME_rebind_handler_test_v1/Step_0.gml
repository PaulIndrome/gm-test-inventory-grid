// gather all information required at the beginning
var _cancelled = keyboard_check_pressed(vk_escape) || gamepad_button_check(0, gp_select);

// currently rebinding any device and intend to cancel
if(rebinding_active && _cancelled){
	reset_rebinding();
	exit;
}

// if we are currently rebinding any device and haven't cancelled, poll for a valid result per step
if(rebinding_active){
	// we need to check for a valid input every frame while rebinding
	// checking only once directly after the device was set to rebind mode will never yield valid results
	var _result = InputDeviceGetRebindingResult(rebinding_device);	
	
	// result is undefined for this frame, when no input was detected on the rebinding device
	if(_result == undefined) exit;
	
	// if the result is the same binding as the current one, we leave it as is and stop rebinding
	if(_result == current_binding){
		reset_rebinding();
		exit;
	}
	
	// this code only runs when the result is neither undefined nor the same as current one, meaning it's valid
	InputBindingSet(rebinding_gamepad, INPUT_VERB.REBIND_TEST, _result);
	
	// stop rebinding after successful rebind
	reset_rebinding();
	
	exit;
}

// the following code only runs when NOT rebinding

// if we are not currently rebinding, check for the "start rebinding" inputs
// here, we use those inputs to also distinguish the device we are rebinding
	
// if keyboard ENTER is pressed, set the keyboard to rebind
if(keyboard_check_pressed(vk_enter)){
	set_rebinding(INPUT_KBM, INPUT_VERB.REBIND_TEST);
	
	exit;
}

// if gamepad button A is pressed, set gamepad to rebind
if(gamepad_button_check(0, gp_face1)){
	set_rebinding(0, INPUT_VERB.REBIND_TEST);
		
	exit;
}