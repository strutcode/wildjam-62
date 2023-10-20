extends CharacterBody2D

var complaints = [
	"Hey, watch it!",
	"I'm standing right here.",
	"Attack the bad guys, not me!",
	"What are you doing!?",
]

func _physics_process(delta):
	velocity.y += 980 * delta

	if is_on_floor() && velocity.y > 0:
		velocity.y = 0

	velocity.x = move_toward(velocity.x, 0, 100 * delta)

	move_and_slide()

func takeDamage(amount):
	velocity.y = -250
	velocity.x = sign(position.x - Game.player.position.x) * 100
	complain()

func complain():
	$Label.show()
	$Label.text = complaints[randi() % complaints.size()]

	await get_tree().create_timer(1.2).timeout

	$Label.hide()
