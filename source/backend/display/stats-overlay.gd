extends CanvasLayer

var text:Label = Label.new()
var group:Node2D = Node2D.new()

var alpha:float:
	get: return group.modulate.a
	set(value): group.modulate.a = value

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = RenderingServer.CANVAS_LAYER_MAX
	text.add_theme_font_override('font', preload('res://assets/fonts/funkin.ttf'))
	text.add_theme_font_size_override('font_size', 20)
	text.add_theme_constant_override('outline_size', 8)
	text.position = Vector2(10, 10)
	text.text = '0 FPS'
	group.add_child(text)
	add_child(group)

func _process(_delta:float):
	if !Scene.scene: return
	var fps:String = Global.trimFloatDisplay(Engine.get_frames_per_second())
	var scene:String = Scene.scene.name
	#if OS.is_debug_build(): text.text = '%s FPS\n%s / %s\nScene: %s\n%s\n%s' % [fps, String.humanize_size(OS.get_static_memory_usage()), String.humanize_size(OS.get_static_memory_peak_usage()), scene, OS.get_processor_name(), OS.get_version_alias()]
	#else:
	text.text = '%s FPS\nScene: %s' % [fps, scene]
