extends Control

@onready var itemList := %ItemList

func _ready():
	itemList.item_selected.connect(itemSelect)

func _input(ev):
	if ev.is_action_pressed('interact'):
		get_parent().remove_child.call_deferred(self)

func _enter_tree():
	get_tree().paused = true
	populateItems.call_deferred()


func _exit_tree():
	get_tree().paused = false

func _process(delta):
	%SkillPoints.text = '%d' % Game.player.skillPoints
	%Gold.text = 'Gold: %d' % Game.player.coins
	%XP.text = 'XP: %d/%d' % [Game.player.xp, Game.player.nextLvl]

func populateItems():
	itemList.clear()

	for item in Game.player.items:
		itemList.add_icon_item(item.icon)

	%ItemList.grab_focus()

func itemSelect(i):
	var item = Game.player.items[i]
	%Title.text = item.name
	if item.expandedDescription.length():
		%Description.text = item.expandedDescription
	else:
		%Description.text = item.description
