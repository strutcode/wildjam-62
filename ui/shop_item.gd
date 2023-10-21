extends PanelContainer

var itemId

func setItem(item):
	%Name.text = item.name
	%Price.text = '%d' % item.price
	%Description.text = item.description
