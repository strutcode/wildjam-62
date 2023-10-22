extends Control

var hurtTween
var unhurtTween

func _ready():
	%HurtBorder.show()
	%HurtBorder.modulate = Color.TRANSPARENT

	await get_tree().process_frame

	Game.player.connect('hurt', hurtReaction)

func _process(delta):
	%XpBar.value = Game.player.getXpPercent()
	%HpBar.target = Game.player.getHpPercent()
	%Level.text = 'Level %d' % Game.player.lvl
	%Coins.text = '%d' % Game.player.coins

func hurtReaction():
	if hurtTween:
		return

	hurtTween = get_tree().create_tween()
	hurtTween.tween_property(%HurtBorder, 'modulate', Color(1, 1, 1, 0.5 if Prefs.reduceFlashing else 0.75), 0.3 if Prefs.reduceFlashing else 0.1)
	hurtTween.tween_property(%HurtBorder, 'modulate', Color.TRANSPARENT, 0.3 if Prefs.reduceFlashing else 0.1)
	hurtTween.play()
	await hurtTween.finished
	hurtTween = null
