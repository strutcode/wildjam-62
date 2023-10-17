extends Node2D

@onready var spirit_sm: MultiMeshInstance2D = $SpiritSm
@onready var spirit_lg = $SpiritLg
@onready var player = get_tree().get_first_node_in_group('player')

func spawnSoulSm(pos: Vector2):
	spirit_sm.add(pos, { 'time': randf() * 10 })

func spawnSoulLg(pos: Vector2):
	spirit_lg.add(pos, { 'time': randf() * 10 })

func _process(delta):
	var types = [spirit_sm, spirit_lg]

	for type in types:
		for i in type.count:
			var time = type.getProp(i, 'time') + delta
			type.setProp(i, 'time', time)

			if player:
				var dist = type.getProp(i, 'pos').distance_to(player.position)
				var falloff = 175.0 / dist ** 1.2
				var move = 500 * falloff * delta

				if dist - move < 10:
					type.rem(i)
					Game.addPoints(10 if type == spirit_lg else 1)
				else:
					var pos = type.getProp(i, 'pos')
					if dist <= 175.0:
						pos = pos.move_toward(player.position, move)

					pos.y += sin(time) * 0.1

					type.setProp(i, 'pos', pos)
