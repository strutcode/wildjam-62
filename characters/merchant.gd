extends CharacterBody2D

var complaints = [
	"Hey, watch it!",
	"I'm standing here you know.",
	"Attack the bad guys, not me!",
	"What are you doing!?",
	"Ouch!",
]

func _ready():
	$Label.hide()

func _physics_process(delta):
	velocity.y += 980 * delta

	if is_on_floor() && velocity.y > 0:
		velocity.y = 0

	velocity.x = move_toward(velocity.x, 0, 100 * delta)

	move_and_slide()

	Game.player.merchantEnabled = false

	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('player'):
			Game.player.merchantEnabled = true

func takeDamage(amount):
	velocity.y = -250
	velocity.x = sign(position.x - Game.player.position.x) * 100
	complain()

func complain():
	$Label.show()
	$Label.text = complaints[randi() % complaints.size()]

	await get_tree().create_timer(1.2).timeout

	$Label.hide()
