extends Control

const ShopItem = preload('res://ui/shop_item.tscn')
const items = [
	'potion',
	'dashup',
	'doublejump',
	'regen',
]

func _enter_tree():
	get_tree().paused = true

	for child in %ItemList.get_children():
		child.queue_free()

	populateItems.call_deferred()

func _exit_tree():
	get_tree().paused = false

func _process(delta):
	if Game.player:
		%Gold.text = '%d' % Game.player.coins

func populateItems():
	for id in items:
		var item = Game.itemDb.find(id)

		if !item:
			print('No item %s' % id)
			continue

		if Game.player.items.has(item):
			continue

		var inst = ShopItem.instantiate()
		inst.setItem(item)
		%ItemList.add_child(inst)

func close():
	get_parent().remove_child(self)
