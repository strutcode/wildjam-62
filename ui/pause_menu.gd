extends Control

const Options = preload('res://ui/options.tscn')

var optionMenu := Options.instantiate()

func _enter_tree():
	get_tree().paused = true
	Game.setBgmLevel(10)
	%Resume.grab_focus.call_deferred()

func _exit_tree():
	get_tree().paused = false
	Game.setBgmLevel(100)

func _input(ev):
	if ev is InputEventKey:
		if ev.pressed && ev.keycode == KEY_ESCAPE:
			resume()

func resume():
	get_parent().remove_child(self)

func options():
	add_child(optionMenu)
	$CenterContainer.visible = false
	await optionMenu.tree_exited
	$CenterContainer.visible = true
	%Resume.grab_focus()

func mainMenu():
	pass

func exit():
	get_tree().quit()
