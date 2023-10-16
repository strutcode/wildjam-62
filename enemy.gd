extends CharacterBody2D

const DeathFX = preload('res://enemy_death_fx.tscn')

@export var speed = 30
@export var acceleration = 10
@export var hp = 30

@onready var player = get_tree().get_first_node_in_group('player')
@onready var sprite = $Enemy

var hit = false

func _process(delta):
	sprite.flip_h = player.position.x > position.x

func _physics_process(delta):
	if hit:
		move_and_slide()
		velocity = velocity.move_toward(Vector2.ZERO, 40)
		return

	var dir = global_position.direction_to(player.global_position)

	velocity = velocity.move_toward(dir * speed, acceleration)

	move_and_slide()

func takeDamage(amt):
	hp -= amt
	hit = true
	modulate = Color(10, 10, 10)
	velocity = -global_position.direction_to(player.global_position) * 400

	await get_tree().create_timer(0.15).timeout

	modulate = Color.WHITE
	if hp <= 0:
		die()
	else:
		await get_tree().create_timer(0.2).timeout
		hit = false

func die():
	var inst = DeathFX.instantiate()
	add_sibling(inst)
	inst.global_position = global_position

	Game.spawnSouls(10, global_position)

	queue_free()
