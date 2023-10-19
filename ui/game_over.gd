extends Control

func _enter_tree():
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false

func playAgain():
	Game.restart()
	get_parent().remove_child(self)

func mainMenu():
	pass # Replace with function body.
