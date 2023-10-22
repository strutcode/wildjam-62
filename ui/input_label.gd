extends RichTextLabel

@export var action: String

var event
var controllerMode = false

func _input(ev):
	if ev is InputEventKey:
		event = ev

	if ev is InputEventKey || ev is InputEventMouseButton:
		controllerMode = false

	if ev is InputEventJoypadButton || ev is InputEventJoypadMotion:
		controllerMode = true

func _process(delta):
	if action:
		getEventFromAction()

	setLabel()

func getEventFromAction():
	if InputMap.has_action(action):
		event = InputMap.action_get_events(action).front()

func setLabel():
	if !event:
		text = '?'
		return

	var label = event.as_text()

	text = label
