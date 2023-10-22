extends Control

func _ready():
	if Game.goodEnd:
		%GoodEnd.show()
	else:
		%BadEnd.show()

	%MainMenu.grab_focus()

func mainMenu():
	Game.goToMenu()
