extends Control

func _enter_tree():
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false

func _process(delta):
	if Game.player:
		%Gold.text = '%d' % Game.player.coins

func close():
	get_parent().remove_child(self)
