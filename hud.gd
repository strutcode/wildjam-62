extends Control


func _process(delta):
	%XpBar.value = Game.player.getXpPercent()
	%HpBar.target = Game.player.getHpPercent()
	%Level.text = str(Game.player.lvl)
	%Coins.text = str(Game.player.coins)
