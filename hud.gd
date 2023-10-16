extends Control


func _process(delta):
	$ProgressBar.value = Game.getXpPercent()
	$Label.text = str(Game.lvl)
