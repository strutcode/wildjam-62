extends Control

signal proceeded
signal finished

@export_multiline var dialogue = ''
@export var speed: float = 25

var lines = []
var time: float = 0

func _ready():
	hide()

	var currentLine = ''
	for line in dialogue.split('\n'):
		if line.is_empty():
			lines.append(currentLine)
			currentLine = ''
		else:
			currentLine += line

	lines.append(currentLine)

func _input(ev):
	if ev.is_action_pressed('attack'):
		emit_signal('proceeded')

func _process(delta):
	time += delta

	if %Dialogue.visible_ratio >= 1:
		%Proceed.modulate = Color.WHITE
	else:
		%Dialogue.visible_characters = speed * time

func start():
	get_tree().paused = true
	show()

	showLine(0)

func showLine(index):
	if index >= lines.size():
		finish()
	else:
		%Dialogue.text = lines[index]
		%Dialogue.visible_characters = 0
		time = 0
		%Proceed.modulate = Color.TRANSPARENT

		await self.proceeded

		if %Dialogue.visible_ratio < 1.0:
			%Dialogue.visible_ratio = 1.0
			await self.proceeded

		showLine(index + 1)

func finish():
	get_tree().paused = false
	hide()
	emit_signal('finished')
