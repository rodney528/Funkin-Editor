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

func _init(_bpm:float, _time:float = 0, _signature:Array = [4, 4]):
	time = _time
	bpm = _bpm
	while _signature.size() < 1: _signature.append(4)
	signature = _signature

func _to_string() -> String:
	return 'CheckpointMeta(Time: %s, BPM: %s, Time Signature: %s)' % [Global.toDisplayTime(time / 1000), Global.trimFloatDisplay(bpm), Global.joinArray(signature, ' / ')]

static func to_string_checkpoints(checkpoints:Array[CheckpointMeta], one_liner:bool = true) -> String:
	var result = '['
	for checkpoint in checkpoints:
		var bruh = [Global.toDisplayTime(checkpoint.time / 1000), Global.trimFloatDisplay(checkpoint.bpm), Global.joinArray(checkpoint.signature, ' / ')]
		if one_liner: result += 'Time => %s, BPM => %s, Time Signature => %s, ' % bruh
		else: result += '\n\tTime => %s, BPM => %s, Time Signature => %s, ' % bruh
	if one_liner:
		result += ']'
		return result.replace(', ]', ']')
	result += '\n]'
	return result.replace(', \n]', '\n]')
