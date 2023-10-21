extends PanelContainer

var item

func setItem(newItem):
	item = newItem
	%Name.text = item.name
	%Price.text = '%d' % item.price
	%Description.text = item.description

func buy():
	if Game.player.coins >= item.price:
		Game.player.coins -= item.price
		Game.player.addItem(item)
