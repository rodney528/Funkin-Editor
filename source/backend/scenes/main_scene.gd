class_name Scene extends Scene2D

@export_file('*.tscn', '*.scn', '*.res') var initial_scene:String

static var scene:Scene2D
static var _self:Scene

func _ready():
	_self = self
	scene = load(initial_scene).instantiate()
	add_child(scene)

static func switchScene(scene_path:String):
	scene.queue_free()
	scene = load(scene_path).instantiate()
	_self.add_child(scene)
