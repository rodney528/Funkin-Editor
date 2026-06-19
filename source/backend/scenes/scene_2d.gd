## The parent scene class used throughtout the project.
class_name Scene2D extends Node2D

## The parent scene. If this scene is a sub-scene! Otherwise, this is null.
var parent:Scene2D
## The sub-scene of this scene, useful for pause menus and shit.
var subScene:Scene2D

## Opens up a sub-scene.
func openSubScene(_subScene:Scene2D, self_process_mode:ProcessMode = PROCESS_MODE_INHERIT):
	process_mode = self_process_mode
	if !_subScene: print('[%s.openSubScene] Sub-Scene is null.' % [get_class()]); return
	Scene._self.add_child(_subScene)

## Loads a sub-scene from it's path.
func loadSubScene(scene_path:String, self_process_mode:ProcessMode = PROCESS_MODE_INHERIT):
	if !Paths.exists(scene_path, Paths.SearchType.RAW):
		print('[%s.loadSubScene] "%s" doesn\'t exist.' % [get_class(), scene_path])
		return
	openSubScene(load(scene_path).instantiate(), self_process_mode)
