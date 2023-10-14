extends CharacterBody2D

@export var speed = 300
@export var acceleration = 0.2
@export var deceleration = 0.75

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += 980 * delta

	var input = Input.get_axis('left', 'right')

	if input:
		velocity.x = move_toward(velocity.x, input * speed, speed * delta / acceleration)
	else:
		velocity.x = move_toward(velocity.x, input * speed, speed * delta / acceleration)

	move_and_slide()
