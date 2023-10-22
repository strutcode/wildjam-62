extends Node2D

func _ready():
	update()

func update():
	var cur
	var next

	for child in get_children():
		if child is Sprite2D:
			if child.modulate == Color.WHITE:
				cur = child

			child.modulate = Color.TRANSPARENT

	match Game.moonPhase:
		'none':
			return
		'new':
			next = $MoonNew
		'waxing':
			next = $MoonWaxing
		'full':
			next = $MoonFull
		'waning':
			next = $MoonWaning

	if cur && next:
		var tween = get_tree().create_tween()
		tween.tween_property(cur, 'modulate', Color(0, 0, 0, 0), 0.5).from(Color.WHITE)
		tween.tween_property(next, 'modulate', Color.WHITE, 0.5)
		tween.play()
	else:
		next.modulate = Color.WHITE

func changePhase():
	match Game.moonPhase:
		'new':
			Game.moonPhase = 'waxing'
		'waxing':
			Game.moonPhase = 'full'
		'full':
			Game.moonPhase = 'waning'
		'waning':
			Game.moonPhase = 'new'

	update()
