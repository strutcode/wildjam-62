extends Node2D

func moonTrigger(body):
	if body.is_in_group('player'):
		Game.moonPhase = 'none'
		$Moon.process_mode = Node.PROCESS_MODE_INHERIT
		$MoonTrigger.queue_free()

		var originalMoon = get_tree().get_first_node_in_group('moon')
		if originalMoon:
			originalMoon.update()

func moonDied():
	Game.player.addItem(Game.itemDb.find('tear'))

func twistedTrigger(body):
	$Twisted.process_mode = Node.PROCESS_MODE_INHERIT
	$TwistedTrigger.queue_free()

func twistedDied():
	Game.player.addItem(Game.itemDb.find('twisted'))
