class_name CheckpointMeta extends Resource

## The time of the change (in milliseconds).
var time:float
## The BPM of the change.
var bpm:float
## The time signature of the change.
var signature:Array

## The time signature numerator.
var beatsPerMeasure:int:
	get: return signature[0]
## The time signature denominator.
var stepsPerBeat:int:
	get: return signature[1]

var stepsPerMeasure:int:
	get: return beatsPerMeasure * stepsPerBeat

func _init(_time:float = 0, _bpm:float = 100, _signature:Array = [4, 4]):
	time = _time
	bpm = _bpm
	while _signature.size() < 1: _signature.append(4)
	signature = _signature

func _to_string():
	return 'CheckpointMeta(time: %s, bpm: %s, signature: %s)' % [time, bpm, signature]
