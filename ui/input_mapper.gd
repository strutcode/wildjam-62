extends HBoxContainer

func setLabel(text):
	$Label.text = text

func setInput(ev: InputEvent):
	if ev:
		$Button.text = ev.as_text()
	else:
		$Button.text = '<none>'
