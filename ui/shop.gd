extends Control

const ShopItem = preload('res://ui/shop_item.tscn')
const items = [
	'potion',
	'dashup',
	'doublejump',
	'regen',
]

func _ready():
	var list := %ItemList

	for child in list.get_children():
		child.queue_free()

	for id in items:
		var item = Game.itemDb.find(id)

		if !item:
			print('No item %s' % id)
			continue

		var inst = ShopItem.instantiate()
		inst.setItem(item)
		list.add_child(inst)

func _enter_tree():
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false

func _process(delta):
	if Game.player:
		%Gold.text = '%d' % Game.player.coins

func close():
	get_parent().remove_child(self)
