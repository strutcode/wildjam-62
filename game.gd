extends Node

const Collectibles = preload('res://collectibles.tscn')

var collectibles

func _ready():
	collectibles = Collectibles.instantiate()
	add_child(collectibles)

func spawnSouls(count, position):
	if !collectibles:
		return

	for i in count:
		collectibles.spawnSoul(position + Vector2(randf_range(-10, 10), randf_range(-10, 10)))
