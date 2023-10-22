extends Node

const enemies = {
	'zombie': preload('res://enemies/zombie.tscn'),
	'skullbat': preload('res://enemies/skullbat.tscn'),
	'ogre': preload('res://enemies/ogre.tscn'),
}

# Settings
var floorHeight = 238
var waveLength = 30.0
var waves = [
	{
		'zombie': 20,
	},
	{
		'skullbat': 10,
	},
	{
		'zombie': 20,
		'skullbat': 10,
	},
	{
		'zombie': 50,
		'skullbat': 25,
	},
	{
		'ogre': 1,
	},
	{
		'zombie': 50,
		'skullbat': 10,
	},
	{
		'skullbat': 100,
	},
	{
		'zombie': 70,
		'skullbat': 70,
	},
	{
		'zombie': 50,
		'skullbat': 25,
	},
	{
		'ogre': 1,
		'zombie': 50,
	},
	{
		'zombie': 100,
		'skullbat': 25,
	},
	{
		'skullbat': 200,
	},
	{
		'zombie': 120,
		'skullbat': 120,
	},
	{
		'zombie': 100,
		'skullbat': 50,
	},
	{
		'ogre': 3,
		'zombie': 50,
	},
	{
		'zombie': 300,
	},
	{
		'skullbat': 200,
	},
	{
		'zombie': 170,
		'skullbat': 170,
	},
	{
		'zombie': 150,
		'skullbat': 250,
		'ogre': 1,
	},
	{
		'ogre': 10,
		'zombie': 200,
		'skullbat': 50,
	},
]

# Flags
var wave = 0
var waveProgress: float = 0
var spawned = {}

func _process(delta):
	var info = waves[wave]

	waveProgress += delta / waveLength
	var modifier = 2.0 if Game.moonPhase == 'full' else 1.0

	for type in info:
		var total = info[type]
		var expected = floor(total * waveProgress) * modifier
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
	waveProgress = 0.0
	spawned = {}

func spawn(enemy):
	if enemies.has(enemy):
		var camera = get_viewport().get_camera_2d()
		var viewportSize = get_viewport().size
		var left = camera.global_position.x - viewportSize.x / camera.zoom.x / 2
		var right = camera.global_position.x + viewportSize.x / camera.zoom.x / 2

		var inst = enemies[enemy].instantiate()
		get_tree().current_scene.add_child(inst)
		inst.position = Vector2(left if randf() < 0.5 else right, randi_range(-40, floorHeight))
