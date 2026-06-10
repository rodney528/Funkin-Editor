class_name Conductor extends Node

var collective = AudioStreamSynchronized.new()
var playback = AudioStreamPlayer.new()

var data:MusicMeta = MusicMeta.new()

var bpm:float = 100
var time:float:
	get: return playback.get_playback_position() * 1000
	set(value):
		playback.seek(value / 1000)
		return value

var curStep:int
var curBeat:int
var curMeasure:int

var curStepFloat:float
var curBeatFloat:float
var curMeasureFloat:float

var stepsPerBeat:int = 4
var beatsPerMeasure:int = 4

var stepTime:float:
	get: return beatTime / stepsPerBeat
var beatTime:float:
	get: return 60 / bpm * 1000
var measureTime:float:
	get: return beatTime * beatsPerMeasure

signal beatHit
signal stepHit
signal measureHit

func _ready():
	playback.stream = collective
	add_child(playback)

func _process(delta:float):
	print(time)
	curStepFloat = time / stepTime;
	curBeatFloat = curStepFloat / 4;
	curMeasureFloat = curBeatFloat / 4;
	if floor(curStepFloat) != curStep:
		curStep = floor(curStepFloat)
		stepHit.emit(curStep)
	if floor(curBeatFloat) != curBeat:
		curBeat = floor(curBeatFloat)
		beatHit.emit(curBeat)
	if floor(curMeasureFloat) != curMeasure:
		curMeasure = floor(curMeasureFloat)
		measureHit.emit(curMeasure)

var _index = 0
func _addResource(res:AudioStream):
	collective.set_sync_stream(_index, res)
	_index += 1

func loadMusic(id:String):
	#print(id)
	reset()
	var res:AudioStream = load('res://assets/music/{id}/audio.ogg'.format({'id': id}))
	#print(res)
	if res:
		_addResource(res)
		# apply bpm shit here
	var meta:JSON = load('res://assets/music/{id}/audio.json'.format({'id': id}))
	#print(meta, ' ', meta.data)
	if meta:
		data.name = meta.data['name']
		data.artist = meta.data['artist']
		#for i in meta.data['checkpoints'].size():
			#for j in meta.data['checkpoints'][i].size():
				#data.checkpoints.append(CheckpointMeta.new())
				#data.checkpoints[j].time = meta.data['checkpoints'][j]['time']
				#data.checkpoints[j].bpm = meta.data['checkpoints'][j]['bpm']
				#data.checkpoints[j].signture = meta.data['checkpoints'][j]['signture']
		#print(data)

func reset():
	for i in _index:
		collective.set_sync_stream(i, null)
