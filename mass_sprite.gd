extends MultiMeshInstance2D

class_name MassSprite

@export var maxCount = 1000
@export var props: Array[String] = []

var count = 0
var last = 0
var data = {}
var full = false

func _ready():
	addProp('pos')
	for prop in props:
		addProp(prop)

	if !multimesh:
		multimesh = MultiMesh.new()
		multimesh.mesh = QuadMesh.new()
		multimesh.mesh.size = texture.get_size()

	multimesh.instance_count = maxCount
	multimesh.visible_instance_count = 0

func addProp(name: String):
	data[name] = []
	data[name].resize(maxCount)

func getProp(index: int, name: String):
	return data[name][index]

func setProp(index: int, name: String, value):
	if data.has(name):
		data[name][index] = value

		if name == 'pos':
			multimesh.set_instance_transform_2d(index, Transform2D.IDENTITY.scaled(Vector2(1, -1)).translated(value))

func add(newPos: Vector2, newData = {}):
	if full:
		return

	multimesh.visible_instance_count += 1
	count += 1
	last = count - 1
	full = count == maxCount

	setProp(last, 'pos', newPos)
	for prop in newData:
		setProp(last, prop, newData[prop])

	multimesh.set_instance_transform_2d(last, Transform2D.IDENTITY.scaled(Vector2(1, -1)).translated(newPos))

func rem(index: int):
	for prop in data:
		setProp(index, prop, getProp(last, prop))

	multimesh.visible_instance_count -= 1
	count -= 1
	last = count - 1
	full = count == maxCount
