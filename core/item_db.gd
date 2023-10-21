extends Node

const GameItem = preload('res://core/game_item.gd')

@export var items: Array[Resource] = []

func find(id):
	for item in items:
		if item.id == id:
			return item

	return null
