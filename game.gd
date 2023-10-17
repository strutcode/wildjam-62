extends Node

const Collectibles = preload('res://collectibles.tscn')

var collectibles
var xp = 0
var lvl = 1
var nextLvl = 110.0

func _ready():
	collectibles = Collectibles.instantiate()
	add_child(collectibles)

func spawnSouls(count, position):
	if !collectibles:
		return

	var c = count

	while c >= 10:
		var pos = position + Vector2(randf_range(-10, 10), randf_range(-10, 10))

		collectibles.spawnSoulLg(pos)
		c -= 10

	while c >= 1:
		var pos = position + Vector2(randf_range(-10, 10), randf_range(-10, 10))

		collectibles.spawnSoulSm(pos)
		c -= 1

func addPoints(num):
	xp += num

	if xp >= nextLvl:
		xp -= nextLvl
		lvl += 1
		nextLvl = log(lvl + 1) * 100 + lvl * 50

func getXpPercent():
	return (xp / nextLvl) * 100
