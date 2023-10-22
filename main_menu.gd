extends Control

const Options = preload('res://ui/options.tscn')

var optionsMenu = Options.instantiate()

func startStory():
	Game.mode = 'story'
	get_tree().change_scene_to_file('res://main.tscn')
	Game.start.call_deferred()

func startEndless():
	Game.mode = 'endless'
	get_tree().change_scene_to_file('res://main.tscn')
	Game.start.call_deferred()

func replayTutorial():
	Game.mode = 'tutorial'
	get_tree().change_scene_to_file('res://tutorial.tscn')
	Game.start.call_deferred()

func showOptions():
	add_child(optionsMenu)

func exit():
	get_tree().quit()
