class_name ChartEditor extends Node2D

# mainly for testing, before strumlines were added and shit
@export var _songOverride:String
@export var _forcedExtraTracks:PackedStringArray

var _menutheme = Global.bgMusic
var songTime:float:
	get: return $currentsong.time
	set(value):
		$currentsong.time = value
		return value

func _ready():
	if Paths.exists(Paths.music('%s/audio' % _songOverride, ['json']), Paths.SearchType.RAW):
		$currentsong.loadMusic(_songOverride)
		for suffix in _forcedExtraTracks:
			$currentsong.addTrack(suffix)
		$currentsong.play()
		$currentsong.playing = false
	$currentsong.process_anyway = true

func initPlayTest():
	get_tree().paused = true
	var subScene = load('res://source/scenes/play_test_scene.tscn').instantiate()
	add_child(subScene)

var _lastplaying = false
func _process(_delta:float):
	if _lastplaying != $currentsong.playing:
		_lastplaying = $currentsong.playing
		if _lastplaying: _menutheme.playing = false
		else: Global.startVolTween()
	if _lastplaying: $time_slider.value = remap(songTime, 0, $currentsong.length, 0, 1)
	$songInfoTxt/info.text = '%s  /  %s\n%s\n%s\n%s\n%s\n%s  /  %s' % [Global.toDisplayTime($currentsong.time / 1000, 3), Global.toDisplayTime($currentsong.length / 1000, 3), $currentsong.curStep, $currentsong.curBeat, $currentsong.curMeasure, Global.trimFloatDisplay($currentsong.currentBPM), $currentsong.beatsPerMeasure, $currentsong.stepsPerBeat]

func _unhandled_input(event:InputEvent):
	if event.is_action_released('ui_home'): songTime = 0
	if event.is_action_released('ui_end'): songTime = $currentsong.length
	if event.is_action_released('ui_select'): $currentsong.playing = !$currentsong.playing
	var boundTime:bool = false
	
	# BACKWARDS
	if event.is_action_pressed('ui_up', true): songTime -= $currentsong.stepLength; boundTime = true
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP): songTime -= $currentsong.beatLength / 2; boundTime = true
	if event.is_action_pressed('ui_page_up', true): songTime -= $currentsong.measureLength; boundTime = true
	# FORWARDS
	if event.is_action_pressed('ui_down', true): songTime += $currentsong.stepLength; boundTime = true
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN): songTime += $currentsong.beatLength / 2; boundTime = true
	if event.is_action_pressed('ui_page_down', true): songTime += $currentsong.measureLength; boundTime = true
	
	# ensure we stay within the song bounds
	if boundTime: songTime = clampf(songTime, 0, $currentsong.length)
	$time_slider.value = remap(songTime, 0, $currentsong.length, 0, 1)
	
	if Input.is_key_pressed(KEY_F12): initPlayTest()

func _on_file_index_pressed(index:int):
	var id = $menu_bar/File.get_item_text(index)
	print('[ChartEditor._on_file_index_pressed] Selected "%s".' % [id])
	match id.to_lower():
		'exit':
			if _lastplaying:
				Global.startVolTween()
			$currentsong.playing = false
			get_tree().change_scene_to_file('res://source/scenes/editor_picker.tscn')

func _on_edit_index_pressed(index:int):
	var id = $menu_bar/Edit.get_item_text(index)
	print('[ChartEditor._on_edit_index_pressed] Selected "%s".' % [id])
	match id.to_lower():
		_: pass

func _on_mouse_entered(): StatsOverlay.alpha = 0.1
func _on_mouse_exited(): StatsOverlay.alpha = 1
	
func _on_rate_slider_value_changed(value:float):
	$currentsong.rate = value
	$rateTxt.text = 'Rate:  %s' % Global.trimFloatDisplay(value)
func _on_time_slider_value_changed(value:float):
	if !_lastplaying: songTime = remap(value, 0, 1, 0, $currentsong.length)

func _on_step_hit(_step:int): pass
func _on_beat_hit(_beat:int): pass
func _on_measure_hit(_measure:int): pass
func _on_bpm_change(_checkpoint:CheckpointMeta): pass
