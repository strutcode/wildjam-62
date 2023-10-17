extends Control


func _process(delta):
	%XpBar.value = Game.getXpPercent()
	%HpBar.value = Game.getHpPercent()
	%Level.text = str(Game.lvl)
	%Coins.text = str(Game.coins)
