// gather all information required at the beginning
var _cancelled = keyboard_check_pressed(vk_escape) || gamepad_button_check(0, gp_select);
var _rebinding = InputDeviceGetRebinding(rebinding_device);

// currently rebinding any device and intend to cancel
if(_rebinding && _cancelled){
	InputDeviceStopAllRebinding();
	exit;
}

// if we are currently rebinding any device and haven't cancelled, poll for a valid result per step
if(_rebinding){
	// gathering current binding could be done once when rebinding is activated instead
	var _current = InputBindingGet(rebinding_gamepad, INPUT_VERB.REBIND_TEST);
	
	// we need to check for a valid input every frame while rebinding
	// checking only once directly after the device was set to rebind mode will never yield valid results
	var _result = InputDeviceGetRebindingResult(rebinding_device);	
	
	// result is undefined for this frame, when no input was detected on the rebinding device
	if(_result == undefined) exit;
	
	// if the result is the same binding as the current one, we leave it as is and stop rebinding
	if(_result == _current){
		InputDeviceStopAllRebinding();
		exit;
	}
	
	// this code only runs when the result is neither undefined nor the same as current one, meaning it's valid
	InputBindingSet(rebinding_gamepad, INPUT_VERB.REBIND_TEST, _result);
	
	// stop rebinding after successful rebind
	InputDeviceStopAllRebinding();
	
	exit;
	
} else { 
	// if we are not currently rebinding, check for the "start rebinding" inputs
	// here, we use those inputs to also distinguish the device we are rebinding
	
	// if keyboard ENTER is pressed, set the keyboard to rebind
	if(keyboard_check_pressed(vk_enter)){
		rebinding_device = INPUT_KBM; // device macros taken from documentation
		rebinding_gamepad = false; // if the input came from keyboard, we are NOT rebinding gamepad
	
		// main call to set device to rebinding mode
		// from next step on, it will scan for ANY input without triggering game or menu verbs
		InputDeviceSetRebinding(INPUT_KBM, true);
	
		exit;
	}

	// if gamepad button A is pressed, set gamepad to rebind
	if(gamepad_button_check(0, gp_face1)){
		rebinding_device = 0; // gamepad devices are distinguished by numbers 0-3
		rebinding_gamepad = true; // if the input came from gamepad, we ARE rebinding gamepad
		
		// main call to set device to rebinding mode
		// from next step on, it will scan for ANY input without triggering game or menu verbs
		InputDeviceSetRebinding(0, true);
		
		exit;
	}
}



