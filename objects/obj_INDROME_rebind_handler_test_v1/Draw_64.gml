var _binding_name = InputVerbGetBindingName(INPUT_VERB.REBIND_TEST); // name of the binding as per https://offalynne.github.io/Input/#/10.2/Binding-Names

draw_text(16, 16, $"{_binding_name} {rebinding_active ? "-> ?" : ""}"); // when rebinding, draw a "-> ?" text next to the binding name

draw_text(16, 32, rebinding_active ? $"{rebinding_device} rebinding" : $"idle"); // show device number when rebinding, "idle" otherwise

var _any_input = false;
var _gamepad_input = gamepad_check_any_input(0);
if(_gamepad_input > -1){
	_any_input = true;
	draw_text(16, 64, $"{_gamepad_input}");
} else if(keyboard_check(vk_anykey)){
	_any_input = true;
	draw_text(16, 64, keyboard_lastkey);
}

if(_any_input){
	draw_set_color(InputCheck(INPUT_VERB.REBIND_TEST) ? c_green : c_red);
	draw_text(16, 80, $"{InputCheck(INPUT_VERB.REBIND_TEST) ? "binding pressed" : "wrong button"}")
} else {
	draw_text(16, 80, $"No button pressed");
}

draw_set_color(c_white);