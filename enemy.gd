extends CharacterBody2D

@export var speed = 30
@export var acceleration = 10

@onready var player = get_tree().get_first_node_in_group('player')

func _physics_process(delta):
	var dir = global_position.direction_to(player.global_position)

	velocity = velocity.move_toward(dir * speed, acceleration)

	move_and_slide()

func takeDamage(amt):
	queue_free()
