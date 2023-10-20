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
		if Game.player.modifiers.has(modifier):
			var value = Game.player.modifiers[modifier]
			$Label2.text = '%.1f%%' % (value * 100)

func increaseStat():
	if Game.player && Game.player.skillPoints > 0:
		if Game.player.modifiers.has(modifier):
			Game.player.modifiers[modifier] += 0.05
			Game.player.skillPoints -= 1
