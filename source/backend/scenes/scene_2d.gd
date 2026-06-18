class_name Scene2D extends Node2D

var parent:Scene2D
var subScene:Scene2D

func loadSubScene(scene_path:String, self_process_mode:ProcessMode = PROCESS_MODE_INHERIT):
	process_mode = self_process_mode
	if !Paths.exists(scene_path, Paths.SearchType.RAW):
		print('[%s.loadSubScene] "%s" doesn\'t exist.' % [get_class(), scene_path])
		return
	Scene._self.add_child(load(scene_path).instantiate())
