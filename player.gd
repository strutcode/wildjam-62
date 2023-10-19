extends CharacterBody2D

const LevelUpper = preload('res://ui/level_upper.tscn')

@export var speed = 450
@export var acceleration = 0.2
@export var deceleration = 0.75
@export var jumpStrength = 400

@onready var sprite = $Stand0001
@onready var animator = $AnimationPlayer
@onready var screenShake = $Camera2D/Wobbler
@onready var slash_sound = $SlashSound

var hp = 100.0
var xp = 0
var lvl = 1
var nextLvl = 110.0
var coins = 0
var doubleJump = false
var invincibility = 0.0

var levelUpper = LevelUpper.instantiate()

func _input(ev):
	if ev.is_action_pressed('jump'):
		if is_on_floor() || doubleJump:
			velocity.y = -jumpStrength

			if not is_on_floor():
				doubleJump = false

	if ev.is_action_pressed('attack'):
		attack()

	if ev.is_action_pressed('super'):
		superAttack()

func _process(delta):
	invincibility -= delta

	if velocity.x < 0:
		$Slash.scale.x = -1
		$Super.scale.x = -1
		sprite.flip_h = true
	elif velocity.x > 0:
		$Slash.scale.x = 1
		$Super.scale.x = 1
		sprite.flip_h = false

	sprite.modulate.a = 0.75 if invincibility > 0 else 1.0

func _physics_process(delta):
	if get_tree().paused:
		return

	if is_on_floor():
		doubleJump = true
	else:
		velocity.y += 980 * 2 * delta

	if animator.is_playing():
		velocity.y = min(velocity.y, velocity.y * 0.5)

	var input = Input.get_axis('left', 'right')

	var decelerateFoce = speed * delta / deceleration
	var accelerateForce = speed * delta / acceleration

	var change = decelerateFoce if sign(input) != sign(velocity.x) else accelerateForce
	velocity.x = move_toward(velocity.x, input * speed if input else 0.0, change)

	move_and_slide()

func attack():
	animator.play('attack')
	slash_sound.play()
	await get_tree().create_timer(0.07).timeout

	var count = $Slash.hit()
	screenShake.add(count ** 0.2 / 4)

func superAttack():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	animator.play('super')
	$SuperSound.play()

	await get_tree().create_timer(1.4).timeout

	slash_sound.play()
	var count = $Super.hit()
	screenShake.add(count ** 0.2)

	await get_tree().create_timer(0.3).timeout

	process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().paused = false

func takeDamage(amount):
	if invincibility > 0:
		return

	hp -= amount
	if hp <= 0:
		Game.end()

	sprite.modulate = Color(10, 10, 10)
	velocity = Vector2.ZERO
	invincibility = 0.8

	await get_tree().create_timer(0.2).timeout

	sprite.modulate = Color.WHITE

func addPoints(num):
	xp += num

	if xp >= nextLvl:
		xp -= nextLvl
		lvl += 1
		nextLvl = log(lvl + 1) * 100 + lvl * 50
		await levelUp()

func addCoins(num):
	coins += num

func getHpPercent():
	return hp

func getXpPercent():
	return (xp / nextLvl) * 100

func levelUp():
	$UI.add_child(levelUpper)
	await levelUpper.finished
