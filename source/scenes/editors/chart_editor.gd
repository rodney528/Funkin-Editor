class_name ChartEditor extends Node2D

var _menutheme = Global.bgMusic
@export var songOverride:String = ''
var songTime:float:
	get: return $currentsong.time
	set(value):
		$currentsong.time = value
		return value

func _ready():
	if Paths.exists(Paths.music('%s/audio' % songOverride, ['json']), Paths.SearchType.RAW):
		$currentsong.loadMusic(songOverride)
		$currentsong.play()
		$currentsong.playing = false

var _menu_vol_tween
var _lastplaying = false
func _process(_delta:float):
	if _lastplaying != $currentsong.playing:
		_lastplaying = $currentsong.playing
		if _lastplaying:
			if _menu_vol_tween: _menu_vol_tween.stop()
			_menutheme.playing = false
		else:
			if _menu_vol_tween: _menu_vol_tween.stop()
			_menu_vol_tween = create_tween().bind_node(self)
			_menutheme.volume = 0
			_menutheme.playing = true
			_menu_vol_tween.tween_property(_menutheme, 'volume', 0.7, 1.3)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed('ui_home'): songTime = 0
	elif event.is_action_pressed('ui_end'): songTime = $currentsong.length
	
	if event.is_action_pressed('ui_accept'):
		$currentsong.playing = !$currentsong.playing
	if event is InputEventMouseButton:
		if event.button_index == 4: # UP
			songTime -= $currentsong.beatTime
		elif event.button_index == 5: # DOWN
			songTime += $currentsong.beatTime

func _on_file_index_pressed(index:int):
	var id = $menu_bar/File.get_item_text(index)
	print('[ChartEditor._on_file_index_pressed] Selected "%s".' % [id])
	match id.to_lower():
		'exit':
			$currentsong.playing = false
			if _menu_vol_tween: _menu_vol_tween.stop()
			_menu_vol_tween = create_tween().bind_node(self)
			_menu_vol_tween.tween_property(_menutheme, 'volume', 0.7, 1.3)
			get_tree().change_scene_to_file('res://source/scenes/editor_picker.tscn')

func _on_edit_index_pressed(index:int):
	var id = $menu_bar/Edit.get_item_text(index)
	print('[ChartEditor._on_edit_index_pressed] Selected "%s".' % [id])
	match id.to_lower():
		_: pass
