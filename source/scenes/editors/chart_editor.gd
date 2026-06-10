extends Node2D

func _ready():
	$conductor.loadMusic('charteditor-theme')
	$conductor.playback.play()
	$conductor.playback.finished.connect(beans)

func beans():
	print('beans')

func _on_file_index_pressed(index:int):
	var id = $menu_bar/File.get_item_text(index)
	print('File: Selected "{id}".'.format({'id': id}))
	match id.to_lower():
		'exit': get_tree().change_scene_to_file('res://source/scenes/editor_picker.tscn')

func _on_edit_index_pressed(index:int):
	var id = $menu_bar/Edit.get_item_text(index)
	print('Edit: Selected "{id}".'.format({'id': id}))
	match id.to_lower():
		_: pass
