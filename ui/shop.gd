extends Control

const ShopItem = preload('res://ui/shop_item.tscn')
const items = [
	'book',
	'potion',
	'dashup',
	'doublejump',
	'regen',
]

func _ready():
	Game.player.item_added.connect(populateItems)

func _enter_tree():
	get_tree().paused = true

	populateItems.call_deferred()

func _exit_tree():
	get_tree().paused = false
	$AudioStreamPlayer.stop()

func _process(delta):
	if Game.player:
		%Gold.text = '%d' % Game.player.coins

func populateItems():
	for child in %ItemList.get_children():
		child.queue_free()

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

	%Done.grab_focus()

func close():
	get_parent().remove_child(self)
