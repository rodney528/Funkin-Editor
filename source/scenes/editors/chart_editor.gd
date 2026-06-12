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
	$currentsong.process_anyway = true

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
	if $currentsong.playing:
		$songInfoTxt/info.text = '%s / %s\n%s\n%s\n%s\n%s\n%s / %s' % [roundi($currentsong.time / 1000), roundi($currentsong.length / 1000), $currentsong.curStep, $currentsong.curBeat, $currentsong.curMeasure, $currentsong.currentBPM, $currentsong.beatsPerMeasure, $currentsong.stepsPerBeat]

func _unhandled_input(event: InputEvent):
	if event.is_action_released('ui_home'): songTime = 0
	if event.is_action_released('ui_end'): songTime = $currentsong.length
	if event.is_action_released('ui_accept'):
		$currentsong.playing = !$currentsong.playing
	# BACKWARDS
	if event.is_action_pressed('ui_up', true): songTime -= $currentsong.stepLength
	elif (event is InputEventMouseButton and event.button_index == 4): songTime -= $currentsong.beatLength
	elif event.is_action_pressed('ui_page_up', true): songTime -= $currentsong.measureLength
	# FORWARDS
	if event.is_action_pressed('ui_up', true): songTime += $currentsong.stepLength
	elif (event is InputEventMouseButton and event.button_index == 5): songTime += $currentsong.beatLength
	elif event.is_action_pressed('ui_page_up', true): songTime += $currentsong.measureLength

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

func _on_step_hit(_step:int): pass
func _on_beat_hit(_beat:int): pass
func _on_measure_hit(_measure:int): pass
func _on_bpm_change(_checkpoint:CheckpointMeta): pass
