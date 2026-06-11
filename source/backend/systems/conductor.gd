class_name Conductor extends Node

@onready var _playback = AudioStreamPlayer.new()

## The data the conductor uses to manage things.
var data:MusicMeta

## The initial BPM.
var initialBPM:float:
	get: return getCheckpointFromTime(0).bpm
## The current BPM.
var currentBPM:float:
	get: return getCheckpointFromTime(time).bpm
var _bpm:float = 0

## The current song time (in milliseconds).
var time:float:
	get: return _playback.get_playback_position() * 1000
	set(value):
		var _value = wrapf(value, 0, length)
		_playback.seek(_value / 1000)
		return _value
var length:float:
	get: return _playback.stream.get_length() * 1000

## The amount of steps into the song.
var curStep:int
## The amount of beats into the song.
var curBeat:int
## The amount of measures into the song.
var curMeasure:int

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
var stepTime:float:
	get: return getTimeInfoFromTime(time).stepTime
## The amount of beats into the song (in milliseconds).
var beatTime:float:
	get: return getTimeInfoFromTime(time).beatTime
## The amount of measures into the song (in milliseconds).
var measureTime:float:
	get: return getTimeInfoFromTime(time).measureTime

## Emitted whenever a step as passed.
signal stepHit(beat:int)
## Emitted whenever a beat as passed.
signal beatHit(step:int)
## Emitted whenever a measure as passed.
signal measureHit(measure:int)

## Whether the conductor is current playing or not.
var playing:bool:
	get: return !_playback.stream_paused
	set(value):
		_playback.stream_paused = !value
		return !value
## The volume of the conductor.
var volume:float = 1:
	get: return _playback.volume_linear
	set(value):
		_playback.volume_linear = value
		return value
## Wether the conductor audio will loop.
var looped:bool = false

func _ready():
	_bpm = initialBPM
	_playback.stream = AudioStreamSynchronized.new()
	_playback.bus = 'Music'
	add_child(_playback)

func _process(_delta:float):
	if !data: return
	if !playing or !_playback.playing: return
	var checkpoint = getCheckpointFromTime(time)
	curStepFloat = (time - checkpoint.time) / stepTime;
	curBeatFloat = curStepFloat / stepsPerBeat;
	curMeasureFloat = curBeatFloat / beatsPerMeasure;
	_bpm = checkpoint.bpm
	
	var lastStep = curStep
	var lastBeat = curBeat
	var lastMeasure = curMeasure
	if floor(curStepFloat) != lastStep:
		curStep = floor(curStepFloat)
		for i in range(lastStep, curStep + 1):
			stepHit.emit(i)
	if floor(curBeatFloat) != lastBeat:
		curBeat = floor(curBeatFloat)
		for i in range(lastBeat, curBeat + 1):
			beatHit.emit(i)
	if floor(curMeasureFloat) != lastMeasure:
		curMeasure = floor(curMeasureFloat)
		for i in range(lastMeasure, curMeasure + 1):
			measureHit.emit(i)
	_playback.finished.connect(func(): if looped: play(0, volume))

var _index = 0
func _addResource(res:AudioStream):
	_playback.stream.stream_count = _index + 1
	_playback.stream.set_sync_stream(_index, res)
	print(_index)
	_index += 1

## Loads a song via its "id".
func loadMusic(id:String, loop:bool = false):
	_reset()
	var res:AudioStream = load(Paths.music('%s/audio' % id))
	if res: _addResource(res)
	for folder in ResourceLoader.list_directory('res://assets/music/%s' % id):
		if folder.begins_with('audio'):
			print(Paths.music('%s/%s' % [id, folder]))
			var _res:AudioStream = load(Paths.music('%s/%s' % [id, folder]))
			if _res: _addResource(_res)
	looped = loop
	data = MusicMeta.new(id)
	print('[Conductor.loadMusic] Loaded song "%s [%s]".' % [data.name, id])
	# apply bpm shit here

## Plays the song from a specific time.
func play(_time:float = 0, _volume:float = 1):
	if _playback.playing: time = _time
	else: _playback.play(_time / 1000)
	volume = _volume

func getTimeInfoFromTime(_time:float) -> TimeInfo:
	var checkpoint = getCheckpointFromTime(_time)
	var _beatTime:float = 60 / checkpoint.bpm * 1000
	return TimeInfo.new(
		_beatTime / checkpoint.stepsPerBeat,
		_beatTime,
		_beatTime * checkpoint.beatsPerMeasure
	)
func getCheckpointFromTime(_time:float) -> CheckpointMeta:
	var change: CheckpointMeta = CheckpointMeta.new(0, _bpm)
	if !data: return change
	if data.checkpoints.size() == 1:
		change = data.checkpoints[0]
		return change
	for checkpoint in data.checkpoints:
		if _time < checkpoint.time: continue
		change = checkpoint
	return change

func _reset():
	playing = false
	looped = false
	for i in _index:
		_playback.stream.set_sync_stream(i, null)
	_index = 0
