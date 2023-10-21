extends Control

signal finished

func _ready():
	for button in %Options.get_children():
		button.pressed.connect(select.bind(button.name))

func _enter_tree():
	get_tree().paused = true
	%Options.get_child(0).grab_focus.call_deferred()

func _exit_tree():
	get_tree().paused = false

func select(nodeName: String):
	get_parent().remove_child(self)
	Game.player.increaseModifier(nodeName.to_lower(), 0.05)
	emit_signal('finished')
