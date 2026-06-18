class_name EditorPicker extends Scene2D

func _ready():
	position = Vector2(get_window().size.x / 2, get_window().size.y / 2)
	$mute_button.button_pressed = Global.bgMusic.muted

func _on_editors_item_activated(index:int):
	var id = $editorsList.get_item_text(index)
	print('[EditorPicker._on_editors_item_activated] Opening "%s" Editor.' % id)
	match id.to_lower():
		'chart': Scene.switchScene('res://source/scenes/editors/chart_editor.tscn')

func _on_mute_button_toggled(value:bool):
	Global.bgMusic.muted = value
