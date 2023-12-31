extends Node

const Collectibles = preload('res://core/collectibles.tscn')
const PauseMenu = preload('res://ui/pause_menu.tscn')
const GameOver = preload('res://ui/game_over.tscn')

var collectibles = Collectibles.instantiate()
var gameOver = GameOver.instantiate()
var menu = PauseMenu.instantiate()
var player

var mode = 'endless'
var timer = 0.0
var score = 0
var moonPhase = 'new'
var goodEnd = false

@onready var itemDb = $ItemDB

func _ready():
	add_child(collectibles)

	get_tree().tree_changed.connect(findPlayer)

func findPlayer():
	var tree = get_tree()

	if tree:
		player = get_tree().get_first_node_in_group('player')

func _input(ev):
	if !get_tree().current_scene:
		return

	var allowedScenes = ['res://main.tscn', 'res://tutorial.tscn']
	if !allowedScenes.has(get_tree().current_scene.scene_file_path):
		return

	if ev.is_action_pressed('pause'):
		pause()

func _process(delta):
	setVolume('Master', Prefs.masterVolume)
	setVolume('Music', Prefs.musicVolume)
	setVolume('SFX', Prefs.sfxVolume)
	setVolume('Collectible', Prefs.collectVolume)

	if mode == 'story':
		timer -= delta
		if timer <= 0:
			mode = 'ending'
			get_tree().change_scene_to_file('res://ending.tscn')

func setBgmLevel(volume: float):
	$AudioStreamPlayer.volume_db = linear_to_db(volume / 100.0) - 20.0

func setVolume(bus: String, volume: float):
	var idx = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(idx, linear_to_db(volume / 100.0))

func start():
	$AudioStreamPlayer.play()

	if mode == 'story':
		timer = 10.0 * 60
	if mode == 'endless':
		score = 0

func end():
	%ExtraUI.add_child(gameOver)

func goToMenu():
	$AudioStreamPlayer.stop()
	gameOver.queue_free()
	gameOver = GameOver.instantiate()
	get_tree().change_scene_to_file('res://main_menu.tscn')

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

func restart():
	gameOver.queue_free()
	gameOver = GameOver.instantiate()
	get_tree().reload_current_scene()
	timer = 10.0 * 60
	score = 0
	if collectibles:
		collectibles.reset()
