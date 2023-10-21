extends Control

const InputMapper = preload('res://ui/input_mapper.tscn')

func _ready():
	linkPreferences()
	populateInputs()

func _enter_tree():
	%Close.grab_focus.call_deferred()

func close():
	get_parent().remove_child(self)

func linkPreferences():
	var nodes = []

	findPrefNodes(self, nodes)

	for node in nodes:
		var key = node.get_meta('prefsKey')

		if node is CheckButton:
			node.button_pressed = Prefs[key]
			node.pressed.connect(func (): Prefs[key] = node.button_pressed)

		if node is Slider:
			node.value = Prefs[key]
			node.value_changed.connect(func (_v): Prefs[key] = node.value)

func findPrefNodes(node, output):
	for child in node.get_children():
		if child.has_meta('prefsKey'):
			output.append(child)

		findPrefNodes(child, output)

func populateInputs():
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		var inst = InputMapper.instantiate()

		inst.setAction(action)
		if events.is_empty():
			inst.setInput(null)
		else:
			inst.setInput(events[0])

		%InputList.add_child(inst)
