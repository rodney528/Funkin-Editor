class_name Conductor extends Node

@onready var _playback = AudioStreamPlayer.new()

## The data the conductor uses to manage things.
var data:MusicMeta
## The bpm and time signature
var checkpoints:Array[CheckpointMeta] = []

## The initial BPM.
var initialBPM:float:
	get: return getCheckpointFromTime(0).bpm
## The current BPM.
var currentBPM:float:
	get: return getCheckpointFromTime(time).bpm
var _bpm:float = 0

var _fake_time:float = 0
## The current song time (in milliseconds).
var time:float = 0:
	get:
		if !playing: return _fake_time
		return _playback.get_playback_position() * 1000
	set(value):
		_playback.seek(value / 1000)
		_fake_time = value
var length:float:
	get: return _playback.stream.get_length() * 1000

## The amount of steps into the song.
var curStep:int = 0
## The amount of beats into the song.
var curBeat:int = 0
## The amount of measures into the song.
var curMeasure:int = 0

## The same as "curStep", but as a percentage.
var curStepFloat:float
## The same as "curBeat", but as a percentage.
var curBeatFloat:float
## The same as "curMeasure", but as a percentage.
var curMeasureFloat:float

## The current amount of *steps per beat* (time signature denominator).
var stepsPerBeat:int:
	get: return getCheckpointFromTime(time).stepsPerBeat
## The current amount of *beats per measure* (time signature numerator).
var beatsPerMeasure:int:
	get: return getCheckpointFromTime(time).beatsPerMeasure
## The current amount of *steps per measure*.
var stepsPerMeasure:int:
	get: return getCheckpointFromTime(time).stepsPerMeasure

## The amount of steps into the song (in milliseconds).
var stepLength:float:
	get: return getInfoFromTime(time).stepLength
## The amount of beats into the song (in milliseconds).
var beatLength:float:
	get: return getInfoFromTime(time).beatLength
## The amount of measures into the song (in milliseconds).
var measureLength:float:
	get: return getInfoFromTime(time).measureLength

## Emitted whenever a step has passed.
signal stepHit(step:int)
## Emitted whenever a beat has passed.
signal beatHit(beat:int)
## Emitted whenever a measure has passed.
signal measureHit(measure:int)

## Emitted whenever a bpm change has passed.
signal bpmHit(checkpoint:CheckpointMeta)

## Whether the conductor is current playing or not.
var playing:bool:
	get: return !_playback.stream_paused or _playback.playing
	set(value):
		# figure out "_fake_time" set
		_playback.stream_paused = !value
		time = _fake_time
var muted:bool = false:
	set(value):
		muted = value
		volume = volume
var _internal_volume:float = 1
## The volume of the conductor.
var volume:float = 1:
	get: return _internal_volume
	set(value):
		_internal_volume = value
		if muted: _playback.volume_linear = 0
		else: _playback.volume_linear = _internal_volume
## How fast the song should play.
var rate:float = 1:
	get: return _playback.pitch_scale
	set(value): _playback.pitch_scale = value
## Wether the conductor audio will loop.
var loop:bool = false

func _ready():
	_playback.bus = 'Music'
	_playback.stream = AudioStreamSynchronized.new()
	_playback.finished.connect(func():
		play(0, volume)
		if !loop:
			playing = false
			time = length
	)
	checkpoints.sort_custom(func(a, b): return a.time < b.time)
	add_child(_playback)

var process_anyway:bool = false
var _prev_checkpoint:CheckpointMeta
var _current_checkpoint:CheckpointMeta
func _process(_delta:float):
	if !(process_anyway or playing): return
	if playing: _fake_time = time
	if _current_checkpoint: _prev_checkpoint = _current_checkpoint
	_current_checkpoint = getCheckpointFromTime(time)
	curStepFloat = getStepFromTime(time) + ((time - _current_checkpoint.time) / stepLength);
	curBeatFloat = curStepFloat / stepsPerBeat;
	curMeasureFloat = curBeatFloat / beatsPerMeasure;
	_bpm = _current_checkpoint.bpm
	
	if _prev_checkpoint:
		if _prev_checkpoint.bpm != _current_checkpoint.bpm:
			bpmHit.emit(_current_checkpoint)
	else: bpmHit.emit(_current_checkpoint)
	
	var lastStep = curStep
	var lastBeat = curBeat
	var lastMeasure = curMeasure
	if floor(curStepFloat) != lastStep:
		curStep = floor(curStepFloat)
		for i in range(lastStep + 1, curStep + 1):
			stepHit.emit(i)
	if floor(curBeatFloat) != lastBeat:
		curBeat = floor(curBeatFloat)
		for i in range(lastBeat + 1, curBeat + 1):
			beatHit.emit(i)
	if floor(curMeasureFloat) != lastMeasure:
		curMeasure = floor(curMeasureFloat)
		for i in range(lastMeasure + 1, curMeasure + 1):
			measureHit.emit(i)

var _index = 0
func _addAudioStream(res:AudioStream):
	_playback.stream.stream_count = _index + 1
	_playback.stream.set_sync_stream(_index, res)
	_index += 1

## Loads a song via its "id".
func loadMusic(id:String, _loop:bool = false):
	_reset()
	var path = Paths.music('%s/audio' % id)
	if !Paths.exists(path, Paths.SearchType.RAW): return
	else: print('[Conductor.loadMusic] Song "%s" doesn\'t exist.' % id)
	var res:AudioStream = load(path)
	if res: _addAudioStream(res)
	loop = _loop
	data = MusicMeta.new(id)
	print('[Conductor.loadMusic] Loaded song "%s" [%s].' % [data.name, id])
	checkpoints.resize(0) # clears any existing checkpoints
	checkpoints.append_array(data.checkpoints) # feeds it the *new* songs checkpoints
	print('[Conductor.loadMusic] Registered Checkpoints: %s' % CheckpointMeta.to_string_checkpoints(checkpoints, false))
	_bpm = initialBPM

func addTrack(suffix:String):
	var path = Paths.music('%s/audio-%s' % [data.id, suffix])
	if !Paths.exists(path, Paths.SearchType.RAW): return
	else: print('[Conductor.addTrack] Song track "%s/audio-%s" doesn\'t exist.' % [data.id, suffix])
	var res:AudioStream = load(path)
	if res: _addAudioStream(res)

## Plays the song from a specific time.
func play(_time:float = 0, _volume:float = 1):
	if _playback.playing: time = _time
	else: _playback.play(_time / 1000)
	volume = _volume

func getStepFromTime(_time:float = 0) -> float:
	var _step:float = 0
	if checkpoints.size() == 0: return _step
	var _tracked_bpm:float = initialBPM
	var last_time:float = 0
	for checkpoint in checkpoints:
		var new_time: float = checkpoint.time + 0
		if _time >= new_time:
			var _step_crochet:float = (60000 / _tracked_bpm) / checkpoint.stepsPerBeat
			_step += (new_time - last_time) / _step_crochet
			last_time = new_time
			_tracked_bpm = checkpoint.bpm
		else: break
	return _step
func getCheckpointFromTime(_time:float) -> CheckpointMeta:
	var change = CheckpointMeta.new(_bpm, _time)
	if checkpoints.size() == 1:
		return checkpoints[0]
	for checkpoint in checkpoints:
		if _time < checkpoint.time: continue
		change = checkpoint
	return change
func getInfoFromTime(_time:float) -> TimeInfo:
	var checkpoint = getCheckpointFromTime(_time)
	var _beatTime:float = 60 / checkpoint.bpm * 1000
	return TimeInfo.new(
		_beatTime / checkpoint.stepsPerBeat,
		_beatTime,
		_beatTime * checkpoint.beatsPerMeasure
	)

func _reset():
	playing = false
	loop = false
	for i in _index:
		_playback.stream.set_sync_stream(i, null)
	_index = 0
