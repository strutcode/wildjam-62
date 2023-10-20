extends Control

func _enter_tree():
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false

func close():
	get_parent().remove_child(self)
