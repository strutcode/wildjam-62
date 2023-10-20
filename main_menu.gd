extends Control

const Options = preload('res://ui/options.tscn')

var optionsMenu = Options.instantiate()

func startStory():
	pass

func startEndless():
	pass

func replayTutorial():
	pass

func showOptions():
	add_child(optionsMenu)

func exit():
	get_tree().quit()
