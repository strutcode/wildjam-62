extends Node2D

@onready var spirit_sm: MultiMeshInstance2D = $SpiritSm
@onready var player = get_tree().get_first_node_in_group('player')

func spawnSoul(pos: Vector2):
	spirit_sm.add(pos, { 'time': randf() * 10 })

func _process(delta):
	for i in spirit_sm.count:
		var time = spirit_sm.getProp(i, 'time') + delta
		spirit_sm.setProp(i, 'time', time)

		if player:
			var dist = spirit_sm.getProp(i, 'pos').distance_to(player.position)
			var falloff = 175.0 / dist ** 1.2
			var move = 500 * falloff * delta

			if dist - move < 10:
				spirit_sm.rem(i)
				Game.addPoint()
			else:
				var pos = spirit_sm.getProp(i, 'pos')
				if dist <= 175.0:
					pos = pos.move_toward(player.position, move)

				pos.y += sin(time) * 0.1

				spirit_sm.setProp(i, 'pos', pos)
