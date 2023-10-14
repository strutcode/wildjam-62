extends CharacterBody2D

@export var speed = 30
@export var acceleration = 10
@export var hp = 30

@onready var player = get_tree().get_first_node_in_group('player')

var hit = false

func _physics_process(delta):
	if hit:
		move_and_slide()
		velocity = velocity.move_toward(Vector2.ZERO, 40)
		return

	var dir = global_position.direction_to(player.global_position)

	velocity = velocity.move_toward(dir * speed, acceleration)

	move_and_slide()

func takeDamage(amt):
	var oldCol = $ColorRect.color

	hp -= amt
	hit = true
	$ColorRect.color = Color.WHITE
	velocity = -global_position.direction_to(player.global_position) * 400

	await get_tree().create_timer(0.15).timeout

	$ColorRect.color = oldCol
	if hp <= 0:
		queue_free()
	else:
		await get_tree().create_timer(0.2).timeout
		hit = false
