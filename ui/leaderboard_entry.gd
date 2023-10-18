extends PanelContainer

func setPlayer(player):
	%Name.text = player.name
	%Score.text = str(player.score)
