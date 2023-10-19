extends Control

var hurtTween
var unhurtTween

func _ready():
	%HurtBorder.modulate = Color.TRANSPARENT

func _process(delta):
	%XpBar.value = Game.player.getXpPercent()
	%HpBar.target = Game.player.getHpPercent()
	%Level.text = str(Game.player.lvl)
	%Coins.text = str(Game.player.coins)

	if !hurtTween && Game.player.invincibility > 0:
		hurtTween = get_tree().create_tween()
		hurtTween.tween_property(%HurtBorder, 'modulate', Color(1, 1, 1, 0.5), 0.2)
		hurtTween.play()

	if hurtTween && Game.player.invincibility <= 0:
		hurtTween = null
		unhurtTween = get_tree().create_tween()
		unhurtTween.tween_property(%HurtBorder, 'modulate', Color.TRANSPARENT, 0.2)
		unhurtTween.play()
