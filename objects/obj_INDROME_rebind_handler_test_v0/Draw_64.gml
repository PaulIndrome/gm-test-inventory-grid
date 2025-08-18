var _binding_name = InputVerbGetBindingName(INPUT_VERB.REBIND_TEST); // name of the binding as per https://offalynne.github.io/Input/#/10.2/Binding-Names
var _rebinding = InputDeviceGetRebinding(rebinding_device); // -1 for keyboard, 0-3 for gamepads

draw_text(16, 16, $"{_binding_name}{_rebinding ? "-> ?" : ""}"); // when rebinding, draw a "-> ?" text next to the binding name

draw_text(16, 32, _rebinding ? $"{rebinding_device} rebinding" : $"idle"); // show device number when rebinding, "idle" otherwise