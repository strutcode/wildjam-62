extends Node

@export var items: Array[Resource] = []

func find(id):
	for item in items:
		if item.id == id:
			return item

	return null
