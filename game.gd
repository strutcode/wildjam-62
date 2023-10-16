extends Node

const Collectibles = preload('res://collectibles.tscn')

var collectibles
var xp = -1
var lvl = 1
var nextLvl = 110.0

func _ready():
	collectibles = Collectibles.instantiate()
	add_child(collectibles)
	addPoint()

func spawnSouls(count, position):
	if !collectibles:
		return

	for i in count:
		collectibles.spawnSoul(position + Vector2(randf_range(-10, 10), randf_range(-10, 10)))

func addPoint():
	xp += 1

	if xp >= nextLvl:
		xp -= nextLvl
		lvl += 1
		nextLvl = log(lvl + 1) * 100 + lvl * 50

func getXpPercent():
	return (xp / nextLvl) * 100
