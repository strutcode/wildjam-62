extends Node2D

func _ready():
	Game.mode = 'tutorial'

	hideAllKeys()
	moveTipTriggered()

func hideAllKeys():
	for node in get_tree().get_nodes_in_group('keyHelpers'):
		node.hide()

func moveTipTriggered():
	%MoveTip.start()
	await %MoveTip.finished
	%MoveKeys.show()

func jumpTipTriggered(body):
	hideAllKeys()
	%JumpTrigger.queue_free()
	%JumpTip.start()
	await %JumpTip.finished
	%JumpKey.show()
	$Zombie.process_mode = PROCESS_MODE_INHERIT

func attackTipTriggered(body):
	hideAllKeys()
	%AttackTrigger.queue_free()
	await get_tree().create_timer(0.35).timeout
	%AttackTip.start()
	await %AttackTip.finished
	%AttackKey.show()

func zombieDied():
	if has_node('%JumpTrigger'):
		%JumpTrigger.queue_free()

	hideAllKeys()
	await get_tree().create_timer(0.5).timeout
	Game.player.xp = Game.player.nextLvl
	%XpTip.start()
	await %XpTip.finished

	%XpKey.show()
	await $Player.opened_inventory
	hideAllKeys()
	%LevelUpTip.start()

func superTipTriggered(body):
	hideAllKeys()
	Game.player.superPoints = Game.player.superThreshold
	%AttackTrigger2.queue_free()
	%SuperTip.start()
	await %SuperTip.finished
	%SuperKey.show()

	for enemy in get_tree().get_nodes_in_group('phase2'):
		enemy.process_mode = Node.PROCESS_MODE_INHERIT

func shopTipTriggered(body):
	%ShopTrigger.queue_free()
	hideAllKeys()
	%ShopTip.start()
	await %ShopTip.finished
	%ShopKey.show()

func finalTipTriggered(body):
	%FinalTip.start()
	await %FinalTip.finished
	mainMenu()

func mainMenu():
	Game.goToMenu()
