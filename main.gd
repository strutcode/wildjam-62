extends Node2D

func moonTrigger(body):
	if body.is_in_group('player'):
		$Moon.process_mode = Node.PROCESS_MODE_INHERIT
