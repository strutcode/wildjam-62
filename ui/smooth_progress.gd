extends ProgressBar

class_name SmoothProgress

@export var target: float
@export var speed = 100.0

func _ready():
	target = value

func _process(delta):
	value = move_toward(value, target, speed * delta)
