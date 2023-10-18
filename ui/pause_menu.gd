extends Control

const Options = preload('res://ui/options.tscn')

var optionMenu := Options.instantiate()

func _enter_tree():
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false

func resume():
	get_parent().remove_child(self)

func options():
	add_child(optionMenu)

func mainMenu():
	pass

func exit():
	get_tree().quit()
