extends CharacterBody2D

@export var speed = 450
@export var acceleration = 0.2
@export var deceleration = 0.75
@export var jumpStrength = 400

@onready var sprite = $Stand0001
@onready var animator = $AnimationPlayer
@onready var screenShake = $Camera2D/Wobbler

var doubleJump = false
var invincibility = 0.0

func _process(delta):
	invincibility -= delta

	if Input.is_action_just_pressed('attack'):
		attack()

	if Input.is_action_just_pressed('super'):
		superAttack()

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

	if Input.is_action_just_pressed('jump'):
		if is_on_floor() || doubleJump:
			velocity.y = -jumpStrength

			if not is_on_floor():
				doubleJump = false

	var input = Input.get_axis('left', 'right')

	var decelerateFoce = speed * delta / deceleration
	var accelerateForce = speed * delta / acceleration

	var change = decelerateFoce if sign(input) != sign(velocity.x) else accelerateForce
	velocity.x = move_toward(velocity.x, input * speed if input else 0.0, change)

	move_and_slide()

func attack():
	animator.play('attack')
	await get_tree().create_timer(0.07).timeout

	var count = $Slash.hit()
	screenShake.add(count ** 0.2 / 4)

func superAttack():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	animator.play('super')

	await get_tree().create_timer(1.4).timeout

	var count = $Super.hit()
	screenShake.add(count ** 0.2)

	await get_tree().create_timer(0.3).timeout

	process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().paused = false

func takeDamage(amount):
	if invincibility > 0:
		return

	Game.hp -= amount
	sprite.modulate = Color(10, 10, 10)
	velocity = Vector2.ZERO
	invincibility = 0.8

	await get_tree().create_timer(0.2).timeout

	sprite.modulate = Color.WHITE
