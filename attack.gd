extends Area2D

@export var damage = 10

func hit():
	var bodies = get_overlapping_bodies()

	for body in bodies:
		if body.has_method('takeDamage'):
			body.takeDamage(damage)
