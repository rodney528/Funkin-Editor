class_name Note extends Sprite2D

const dirAngles:Array[int] = [0, 270, 90, 180]

var field:ArrowField
var strum:Strum

var id:int
var time:float
var type:StringName = &'default'

var skin:String = 'base'

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
	texture = load(Paths.image('arrows/%s/note head' % skin))
	modulate = QuantUtil._unknownColor
	scale = Vector2(0.7, 0.7)
