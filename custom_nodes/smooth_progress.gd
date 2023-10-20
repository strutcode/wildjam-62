extends ProgressBar

class_name SmoothProgress

@export var target: float
@export var speed = 100.0
@export var minSpeed = 1.0
@export var exponent = 2.0

func _ready():
	target = value

func _process(delta):
	var diff = (target - value) / max_value
	value = move_toward(value, target, max(minSpeed, pow(diff * 10, exponent) * speed * delta))
