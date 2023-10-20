extends CharacterBody2D

const LevelUpper = preload('res://ui/level_upper.tscn')
const Inventory = preload('res://ui/inventory.tscn')

@export var speed = 620.0
@export var acceleration = 0.2
@export var deceleration = 0.75
@export var jumpStrength = 550.0

@onready var sprite = $AnimatedSprite2D
@onready var animator = $AnimationPlayer
@onready var screenShake = $Camera2D/Wobbler
@onready var slash_sound = $SlashSound

# Scemes
var levelUpper = LevelUpper.instantiate()
var inventoryViewer = Inventory.instantiate()

# Stats
var hp: float = 100
var maxHp: float = 100
var damage: float = 10
var defense: float = 0.8
var modifiers = {
	'attack': 1.0,
	'damage': 1.0,
	'defense': 1.0,
	'speed': 1.0,
	'jump': 1.0,
	'health': 1.0,
}

# Progression
var xp = 0
var lvl = 1
var nextLvl: float = 110
var skillPoints = 0

# Inventory
var coins = 0

# Flags
var doubleJump = false
var attackFrames: float = 0
var invincibility: float = 0

func _input(ev):
	if ev.is_action_pressed('jump'):
		if is_on_floor() || doubleJump:
			velocity.y = -jumpStrength * modifiers.jump

			if not is_on_floor():
				doubleJump = false

	if ev.is_action_pressed('attack'):
		attack()

	if ev.is_action_pressed('super'):
		superAttack()

	if ev.is_action_pressed('interact'):
		if !inventoryViewer.is_inside_tree():
			$UI.add_child(inventoryViewer)

func _process(delta):
	invincibility -= delta
	attackFrames -= delta

	$Slash.damage = damage * modifiers.damage
	$Super.damage = damage * 3 * modifiers.damage

	if velocity.x < 0:
		$Slash.scale.x = -1
		$Super.scale.x = -1
		sprite.flip_h = true
	elif velocity.x > 0:
		$Slash.scale.x = 1
		$Super.scale.x = 1
		sprite.flip_h = false

	sprite.modulate.a = 0.75 if invincibility > 0 else 1.0

	animate()

func _physics_process(delta):
	if get_tree().paused:
		return

	if is_on_floor():
		doubleJump = true
	else:
		velocity.y += delta * 980 * 2

	if animator.is_playing():
		velocity.y = min(velocity.y, velocity.y * 0.5)

	var input = Input.get_axis('left', 'right')
	var modSpeed = speed * modifiers.speed

	var decelerateFoce = modSpeed * delta / deceleration
	var accelerateForce = modSpeed * delta / acceleration

	var change = decelerateFoce if sign(input) != sign(velocity.x) else accelerateForce
	velocity.x = move_toward(velocity.x, input * modSpeed if input else 0.0, change)

	move_and_slide()

func animate():
	if attackFrames > 0:
		sprite.play('slash1')
	elif velocity.y < -5:
		sprite.play('jump')
	elif velocity.y > 5:
		sprite.play('fall')
	elif abs(velocity.x) > 5:
		sprite.play('run')
		sprite.speed_scale = velocity.x / 12 * 0.03
	else:
		sprite.play('stand')
		sprite.speed_scale = 1.0

func attack():
	animator.play('attack')
	slash_sound.play()
	attackFrames = 0.17
	await get_tree().create_timer(0.07).timeout

	var count = $Slash.hit()
	screenShake.add(min(count * 0.2, 0.8))

func superAttack():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	animator.play('super')
	$SuperSound.play()

	await get_tree().create_timer(1.4).timeout

	slash_sound.play()
	$Super.hit()
	screenShake.add(1.0)

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
	invincibility = defense * modifiers.defense
	screenShake.add(1.0)

	await get_tree().create_timer(0.2).timeout

	sprite.modulate = Color.WHITE

func addPoints(num):
	xp += num
	Game.score += num

	if xp >= nextLvl:
		xp -= nextLvl
		lvl += 1
		skillPoints += 1
		Game.score += lvl * 100
		nextLvl = log(lvl + 1) * 100 + lvl * 50
		await levelUp()

func addCoins(num):
	coins += num
	Game.score += num * 10

func getHpPercent():
	return (hp / (maxHp * modifiers.health)) * 100

func getXpPercent():
	return (xp / nextLvl) * 100

func levelUp():
	$UI.add_child(levelUpper)
	await levelUpper.finished

func getModifier(modifier):
	if modifiers.has(modifier):
		return modifiers[modifier]

	return 1.0

func increaseModifier(modifier, amount):
	if modifiers.has(modifier):
		modifiers[modifier] += amount
		skillPoints -= 1
