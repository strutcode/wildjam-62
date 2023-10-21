extends Node

# Game
@export var autoLevel = true

# Audio
@export var masterVolume = 100.0
@export var musicVolume = 100.0
@export var sfxVolume = 100.0
@export var collectVolume = 100.0

# Visual
@export var particles = true
@export var gpuParticles = true
@export var gore = true
@export var screenShake = true
@export var reduceFlashing = false

func _ready():
	restore()

func setPref(prop, value):
	self[prop] = value
	persist()

func persist():
	var data = var_to_str(self)
	var file = FileAccess.open('user://prefs', FileAccess.WRITE)
	file.store_string(data)
	file.close()

func restore():
	var file = FileAccess.open('user://prefs', FileAccess.READ)
	if file:
		var data = file.get_as_text()
		var obj = str_to_var(data)

		for prop in obj.get_property_list():
			if prop.hint == 0 && prop.usage == 4102:
				self[prop.name] = obj[prop.name]
