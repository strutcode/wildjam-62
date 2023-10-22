extends Control

const Leaderboard = preload('res://ui/leaderboard.tscn')

func _enter_tree():
	get_tree().paused = true

	if Game.mode == 'endless':
		var leaderboard = Leaderboard.instantiate()
		leaderboard.custom_minimum_size = Vector2(800, 600)
		%GameOver.add_sibling.call_deferred(leaderboard)

func _exit_tree():
	get_tree().paused = false

func playAgain():
	Game.restart()
	get_parent().remove_child(self)

func mainMenu():
	Game.goToMenu()
	queue_free()
