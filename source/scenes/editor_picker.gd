extends Node2D

func _ready():
	position.x = get_window().size.x / 2
	position.y = get_window().size.y / 2

func _on_editors_item_activated(index:int):
	var id = $editorsList.get_item_text(index)
	print('Opening "{id}" Editor.'.format({'id': id}))
	match id.to_lower():
		'chart': get_tree().change_scene_to_file('res://source/scenes/editors/chart_editor.tscn')
