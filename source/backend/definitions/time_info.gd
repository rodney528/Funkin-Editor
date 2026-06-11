class_name TimeInfo extends Node

# The amount of steps into the song (in milliseconds).
var stepTime:float
## The amount of beats into the song (in milliseconds).
var beatTime:float
## The amount of measures into the song (in milliseconds).
var measureTime:float

func _init(_stepTime:float, _beatTime:float, _measureTime:float):
	stepTime = _stepTime
	beatTime = _beatTime
	measureTime = _measureTime
