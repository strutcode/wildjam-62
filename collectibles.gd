extends Node2D

@onready var spirit_sm: MultiMeshInstance2D = $SpiritSm
@onready var player = get_tree().get_first_node_in_group('player')

var sp_t = []
var sp_p = []
var invalidT = Transform2D.IDENTITY.translated(Vector2(-10000, -10000))

func _ready():
	sp_t.resize(10000)
	sp_p.resize(10000)

	spirit_sm.multimesh.instance_count = 10000
	spirit_sm.multimesh.visible_instance_count = 0

func spawnSoul(pos: Vector2):
	var mm = spirit_sm.multimesh

	if mm.visible_instance_count >= 10000:
		return

	var i = mm.visible_instance_count
	mm.visible_instance_count += 1

	sp_t[i] = randf() * 10
	sp_p[i] = pos

	mm.set_instance_transform_2d(i, Transform2D.IDENTITY.scaled(Vector2(1, -1)).translated(pos))

func _process(delta):
	var mm = spirit_sm.multimesh

	for i in mm.visible_instance_count:
		sp_t[i] += delta

		if player:
			var dist = sp_p[i].distance_to(player.position)
			var falloff = 175.0 / dist ** 1.2
			var move = 500 * falloff * delta

			if dist - move < 10:
				var c = mm.visible_instance_count - 1

				sp_p[i] = sp_p[c]
				sp_t[i] = sp_t[c]
				mm.visible_instance_count -= 1

				Game.addPoint()
			else:
				if dist <= 175.0:
					sp_p[i] = sp_p[i].move_toward(player.position, move)

				mm.set_instance_transform_2d(i, Transform2D.IDENTITY.scaled(Vector2(1, -1)).translated(sp_p[i] + Vector2(0, sin(sp_t[i]) * 10)))
