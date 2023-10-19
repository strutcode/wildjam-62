extends MarginContainer

func _enter_tree():
	if get_index() % 2 == 0:
		$ColorRect.color.a = 70.0 / 255

func setPlayer(player):
	%Name.text = player.name
	%Score.text = str(player.score)
