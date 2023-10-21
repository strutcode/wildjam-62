extends Node

class_name Wobbler

@export var noise: FastNoiseLite
@export var speed: float = 2
@export var strength: Vector2 = Vector2(30, 30)
@export var decay: float = 0.8

var wobble = 0.0
var unique = randf() * 100

func _process(delta):
	var parent = get_parent()
	var t = (Time.get_ticks_msec() / 1000.0) * speed

	if parent is Node2D:
		var x = noise.get_noise_2d(t, unique)
		var y = noise.get_noise_2d(unique, t)
		get_parent().position = Vector2(x, y) * wobble * strength

	wobble = move_toward(wobble, 0, delta * decay)

func add(amount: float):
	wobble += amount

func addUpTo(amount: float, maximum: float):
	wobble = max(min(wobble + amount, maximum), wobble)
