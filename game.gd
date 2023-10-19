extends Node

const Collectibles = preload('res://collectibles.tscn')
const LevelUpper = preload('res://ui/level_upper.tscn')
const PauseMenu = preload('res://ui/pause_menu.tscn')
const GameOver = preload('res://ui/game_over.tscn')

var collectibles = Collectibles.instantiate()
var levelUpper = LevelUpper.instantiate()
var gameOver = GameOver.instantiate()
var menu = PauseMenu.instantiate()

var hp = 100.0
var xp = 0
var lvl = 1
var nextLvl = 110.0
var coins = 0

func _ready():
	add_child(collectibles)

func _input(ev):
	if ev is InputEventKey:
		if ev.pressed && ev.keycode == KEY_ESCAPE:
			pause()

func end():
	%ExtraUI.add_child(gameOver)

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

func spawnCoins(count, position):
	if !collectibles:
		return

	for i in count:
		var pos = position + Vector2(randf_range(-10, 10), randf_range(-10, 10))

		collectibles.spawnCoin(pos, Vector2(randf_range(-250, 250), -400))

func addPoints(num):
	xp += num

	if xp >= nextLvl:
		xp -= nextLvl
		lvl += 1
		nextLvl = log(lvl + 1) * 100 + lvl * 50
		await levelUp()

func addCoins(num):
	coins += num

func getHpPercent():
	return hp

func getXpPercent():
	return (xp / nextLvl) * 100

func levelUp():
	%ExtraUI.add_child(levelUpper)
	await levelUpper.finished

func pause():
	if menu.is_inside_tree():
		return

	%ExtraUI.add_child(menu)
