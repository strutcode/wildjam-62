extends Node

const Collectibles = preload('res://collectibles.tscn')
const PauseMenu = preload('res://ui/pause_menu.tscn')
const GameOver = preload('res://ui/game_over.tscn')

var collectibles = Collectibles.instantiate()
var gameOver = GameOver.instantiate()
var menu = PauseMenu.instantiate()
var player

func _ready():
	add_child(collectibles)

	get_tree().tree_changed.connect(findPlayer)

func findPlayer():
	var tree = get_tree()

	if tree:
		player = get_tree().get_first_node_in_group('player')

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

func pause():
	if menu.is_inside_tree():
		return

	%ExtraUI.add_child(menu)
