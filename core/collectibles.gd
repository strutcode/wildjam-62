extends Node2D

@onready var spirit_sm: MultiMeshInstance2D = $SpiritSm
@onready var spirit_lg = $SpiritLg
@onready var coins = $Coins
@onready var coin1 = $AudioStreamPlayer
@onready var soul1 = $AudioStreamPlayer2

var coinsfx = 0
var soulsfx = 0

func spawnSoulSm(pos: Vector2):
	spirit_sm.add(pos, { 'time': randf() * 10, 'delay': 0.5 })

func spawnSoulLg(pos: Vector2):
	spirit_lg.add(pos, { 'time': randf() * 10, 'delay': 0.5 })

func spawnCoin(pos: Vector2, velocity = Vector2.ZERO):
	coins.add(pos, { 'vel': velocity, 'delay': 0.5 })

func reset():
	spirit_sm.clear()
	spirit_lg.clear()
	coins.clear()

func _process(delta):
	var types = [spirit_sm, spirit_lg]

	for type in types:
		for i in type.count:
			var time = type.getProp(i, 'time') + delta
			var pos = type.getProp(i, 'pos')
			var delay = type.getProp(i, 'delay')
			type.setProp(i, 'time', time)

			delay -= delta
			type.setProp(i, 'delay', delay)

			if Game.player && delay <= 0:
				var dist = pos.distance_to(Game.player.position)
				var falloff = 175.0 / dist ** 1.2
				var move = 500 * falloff * delta

				if dist - move < 10:
					type.rem(i)
					Game.player.addPoints(10 if type == spirit_lg else 1)
					soulSound()
				else:
					if dist <= 175.0:
						pos = pos.move_toward(Game.player.position, move)

					pos.y += sin(time) * 0.1

					type.setProp(i, 'pos', pos)

func _physics_process(delta):
	var floor = get_tree().get_first_node_in_group('floor')

	if floor:
		var bounds = Rect2(floor.global_position, floor.size * floor.get_parent().scale)
		var top = bounds.position.y

		for i in coins.count:
			var pos = coins.getProp(i, 'pos')
			var vel = coins.getProp(i, 'vel')
			var delay = coins.getProp(i, 'delay')
			var destroy = false

			if pos.y < top - 1.5:
				vel.y += 980 * delta

			if pos.y <= top && pos.y + vel.y * delta > top:
				pos.y -= bounds.position.y - pos.y
				vel.y = -vel.y * 0.4

			pos += vel * delta
			vel *= 0.98
			delay -= delta

			if Game.player && delay <= 0:
				var dist = pos.distance_to(Game.player.position)
				var falloff = 175.0 / dist ** 1.2
				var move = 500 * falloff * delta

				if dist - move < 10:
					destroy = true
					Game.player.addCoins(1)
					coinSound()
				else:
					if dist <= 175.0:
						pos = pos.move_toward(Game.player.position, move)

			if destroy:
				coins.rem(i)
			else:
				coins.setProp(i, 'vel', vel)
				coins.setProp(i, 'pos', pos)
				coins.setProp(i, 'delay', delay)

func coinSound():
	if coinsfx < 10:
		coin1.play()
		coinsfx += 1

		await get_tree().create_timer(0.07).timeout

		coinsfx -= 1

func soulSound():
	if soulsfx < 10:
		soul1.play()
		soulsfx += 1

		await get_tree().create_timer(0.07).timeout

		soulsfx -= 1
