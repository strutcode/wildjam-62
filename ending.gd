extends Control

func _ready():
	if Game.goodEnd:
		%GoodEnd.show()
		%GoodEnd2.show()
	else:
		%BadEnd.show()

	%MainMenu.grab_focus()

func mainMenu():
	Game.goToMenu()
