extends Node

const enemies = {
	'zombie': preload('res://enemies/zombie.tscn'),
	'skullbat': preload('res://enemies/skullbat.tscn'),
	'ogre': preload('res://enemies/ogre.tscn'),
}

# Settings
var floorHeight = 238
var waveLength = 20.0
var waves = [
	{
		'zombie': 20,
	},
	{
		'skullbat': 10,
	},
	{
		'ogre': 1,
	},
]

# Flags
var wave = 0
var waveProgress: float = 0
var spawned = {}

func _process(delta):
	var info = waves[wave]

	waveProgress += delta / waveLength

	for type in info:
		var total = info[type]
		var expected = floor(total * waveProgress)
		var actual = spawned.get(type, 0)

		while actual < expected:
			spawn(type)
			actual += 1

		spawned[type] = actual

	if waveProgress >= 1:
		nextWave()

func nextWave():
	wave += 1
	wave = wave % waves.size()
	waveProgress = 0

func spawn(enemy):
	if enemies.has(enemy):
		var camera = get_viewport().get_camera_2d()
		var viewportSize = get_viewport().size
		var left = camera.global_position.x - viewportSize.x / camera.zoom.x / 2
		var right = camera.global_position.x + viewportSize.x / camera.zoom.x / 2

		var inst = enemies[enemy].instantiate()
		get_tree().current_scene.add_child(inst)
		inst.position = Vector2(left if randf() < 0.5 else right, randi_range(-40, floorHeight))
