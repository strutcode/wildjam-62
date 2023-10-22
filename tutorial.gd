extends Node2D

const Zombie = preload('res://enemies/zombie.tscn')

func _ready():
	%MoveKeys.hide()
	%JumpKey.hide()

	moveTipTriggered()

func moveTipTriggered():
	%MoveTip.start()
	await %MoveTip.finished
	%MoveKeys.show()


func jumpTipTriggered(body):
	%MoveKeys.hide()
	%JumpTrigger.queue_free()
	%JumpTip.start()
	await %JumpTip.finished
	%JumpKey.show()
	var inst = Zombie.instantiate()
	add_child(inst)
	inst.position = %EnemySpawn.position
