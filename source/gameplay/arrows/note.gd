class_name Note extends Sprite2D

const dirAngles:PackedInt64Array = [0, 270, 90, 180]

var field#:ArrowField
var strum:Strum

var id:int
var time:float
var type:StringName = &'default'

var wasHit = false
var wasMissed = false
func canHit() -> bool:
	return false
func tooLate() -> bool:
	return true

func _init(_id:int, _time:float):
	id = _id
	time = _time

func _ready():
	texture = load('res://assets/images/arrows/base/note head.png')
	modulate = QuantUtil._unknownQuantColor
