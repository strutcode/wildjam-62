extends Control

signal finished

func _ready():
	for button in %Options.get_children():
		button.pressed.connect(select, )

func _enter_tree():
	get_tree().paused = true
	%Options.get_child(0).grab_focus.call_deferred()

func _exit_tree():
	get_tree().paused = false

func select():
	get_parent().remove_child(self)
	emit_signal('finished')
