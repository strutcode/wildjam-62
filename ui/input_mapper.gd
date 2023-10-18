extends HBoxContainer

var action

func setAction(newAction):
	action = newAction
	$Label.text = action

func setInput(ev: InputEvent):
	if ev:
		$Button.text = ev.as_text()
	else:
		$Button.text = '<none>'

func rebind():
	if InputMap.has_action(action):
		InputMap.action_erase_events(action)

		var ev
		var valid = false
		while not valid:
			ev = await get_window().window_input
			valid = ev is InputEventMouseButton || ev is InputEventJoypadButton || ev is InputEventKey

		InputMap.action_add_event(action, ev)
		setInput(ev)
