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
	%SuperBar.value = getSuperPercent()
	%SuperBackupBar.value = getSuperBackupPercent()

	match Game.mode:
		'story':
			var minutes = floor(Game.timer / 60)
			var seconds = int(floor(Game.timer)) % 60
			%TimeScore.text = '%02d:%02d' % [minutes, seconds]
		'endless':
			%TimeScore.text = '%d' % Game.score

func getSuperPercent():
	return clamp(float(Game.player.superPoints) / float(Game.player.superThreshold), 0, 1) * 100

func getSuperBackupPercent():
	return clamp(float(Game.player.superPoints - Game.player.superThreshold) / float(Game.player.superThreshold), 0, 1) * 100

func hurtReaction():
	if hurtTween:
		return

	hurtTween = get_tree().create_tween()
	hurtTween.tween_property(%HurtBorder, 'modulate', Color(1, 1, 1, 0.5 if Prefs.reduceFlashing else 0.75), 0.3 if Prefs.reduceFlashing else 0.1)
	hurtTween.tween_property(%HurtBorder, 'modulate', Color.TRANSPARENT, 0.3 if Prefs.reduceFlashing else 0.1)
	hurtTween.play()
	await hurtTween.finished
	hurtTween = null
