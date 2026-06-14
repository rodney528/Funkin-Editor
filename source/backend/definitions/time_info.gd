class_name TimeInfo extends Node

## The amount of steps into the song (in milliseconds).
var stepLength:float
## The amount of beats into the song (in milliseconds).
var beatLength:float
## The amount of measures into the song (in milliseconds).
var measureLength:float

func _init(_stepLength:float, _beatLength:float, _measureLength:float):
	stepLength = _stepLength
	beatLength = _beatLength
	measureLength = _measureLength

func _to_string() -> String:
	return 'TimeInfo(Step Length: "%s", Beat Length: "%s", Measure Length: %s)' % [stepLength, beatLength, measureLength]
