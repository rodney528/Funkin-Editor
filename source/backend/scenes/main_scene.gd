## The main scene of the entire project.
class_name Scene extends Node2D

@export_file('*.tscn', '*.scn', '*.res') var initial_scene:String

static var scene:Scene2D
static var _self:Scene

func _ready():
	_self = self
	if ResourceLoader.exists(initial_scene):
		scene = load(initial_scene).instantiate()
	else:
		ErrorScene.inputText = 'Scene "%s" is unknown, please try a different scene.' % initial_scene
		scene = preload('res://source/backend/scenes/error_scene.tscn').instantiate()
	add_child(scene)

static func switchScene(scene_path:String):
	scene.queue_free()
	scene = load(scene_path).instantiate()
	_self.add_child(scene)
