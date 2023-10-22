extends CharacterBody2D

const DeathFX = preload('res://effects/enemy_death_fx.tscn')

@export var speed = 30
@export var acceleration = 10
@export var hp: float = 30
@export var xpMin = 7
@export var xpMax = 12
@export var goldMin = 7
@export var goldMax = 12

@onready var sprite = $Sprite
@onready var hpBar = $HP
@onready var wobbler = $Sprite/Wobbler
@onready var attack = $Attack

var hit = false
var maxHp: float = hp
var unique = randf()

func _ready():
	hpBar.value = 1
	attack.body_entered.connect(touch)

func _process(delta):
	sprite.flip_h = Game.player.position.x > position.x

func _physics_process(delta):
	if hit:
		move_and_slide()
		velocity = velocity.move_toward(Vector2.ZERO, 40)
		return

	var dir = global_position.direction_to(Game.player.global_position)

	velocity = velocity.move_toward(dir * speed, acceleration)

	move_and_slide()

func touch(body):
	if body.is_in_group('player'):
		body.takeDamage(5)

func takeDamage(amt):
	hp -= amt
	hit = true
	hpBar.value = hp / maxHp
	modulate = Color(10, 10, 10)
	velocity = -global_position.direction_to(Game.player.global_position) * 400

	wobbler.add(0.5)

	await get_tree().create_timer(0.15).timeout

	modulate = Color.WHITE
	if hp <= 0:
		die()
	else:
		await get_tree().create_timer(0.2).timeout
		hit = false

func die():
	if Prefs.particles:
		var inst = DeathFX.instantiate()
		add_sibling(inst)
		inst.global_position = global_position

	Game.score += 25

	Game.spawnSouls(randi_range(xpMin, xpMax), global_position)
	Game.spawnCoins(randi_range(goldMin, goldMax), global_position)

	queue_free()
