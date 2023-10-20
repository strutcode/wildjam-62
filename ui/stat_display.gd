@tool
extends HBoxContainer

@export var modifier: String
@export var label: String:
	set(value):
		$Label.text = value
		label = value

func _process(delta):
	if Engine.is_editor_hint():
		return

	if Game.player:
		var value = Game.player.getModifier(modifier)
		$Label2.text = '%.1f%%' % (value * 100)

		$Increment.modulate = Color.WHITE if Game.player.skillPoints > 0 else Color.TRANSPARENT

func increaseStat():
	if Game.player && Game.player.skillPoints > 0:
		Game.player.increaseModifier(modifier, 0.05)
