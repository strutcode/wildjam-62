extends Control


func _process(delta):
	$ProgressBar.value = Game.getXpPercent()
	%Level.text = str(Game.lvl)
	%Coins.text = str(Game.coins)
