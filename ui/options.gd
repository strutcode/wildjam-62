extends Control

const InputMapper = preload('res://ui/input_mapper.tscn')

func _ready():
	populateInputs()

func close():
	get_parent().remove_child(self)

func populateInputs():
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		var inst = InputMapper.instantiate()

		inst.setLabel(action)
		if events.is_empty():
			inst.setInput(null)
		else:
			inst.setInput(events[0])

		%InputList.add_child(inst)
