extends Control

func _ready():
	%MainMenu.grab_focus()

func mainMenu():
	Game.goToMenu()
