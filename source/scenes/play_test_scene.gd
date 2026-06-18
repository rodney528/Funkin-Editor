class_name PlayTestScene extends Scene2D

func _ready():
	Global.bgMusic.playing = false

func _unhandled_input(event:InputEvent):
	if event.is_action_pressed('ui_cancel'):
		queue_free()
		Scene.scene.process_mode = Node.PROCESS_MODE_INHERIT
		Scene.scene.get_node('currentsong').playing = false
		Global.startVolTween()
