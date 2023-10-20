extends Control

@onready var itemList := %ItemList

func _ready():
	itemList.item_selected.connect(itemSelect)

func _input(ev):
	if ev.is_action_pressed('interact'):
		get_parent().remove_child.call_deferred(self)

func _enter_tree():
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false

func _process(delta):
	%SkillPoints.text = '%d' % Game.player.skillPoints

func itemSelect(i):
	var title = %Title
	var desc = %Description

	match i:
		0:
			title.text = 'Death Scythe'
			desc.text = 'My trusty weapon'
		1:
			title.text = 'Souls'
			desc.text = 'Souls collected for the harvest'
		2:
			title.text = 'Blood of the Sacrificed'
			desc.text = '???'
