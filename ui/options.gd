extends Control

func close():
	get_parent().remove_child(self)
