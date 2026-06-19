class_name Note extends Sprite2D

const DEFAULT_NOTE_TYPE:StringName = &'default'
const directionAngles:Array[int] = [0, 270, 90, 180]

var strum:Strum
var field:ArrowField:
	get: return strum.field

var mania_data:KeyCountUtil.KeyCountData:
	get: return KeyCountUtil.getData(local_mania)
var local_mania:int


var id:int:
	get: return strum.id
var time:float
var type:StringName = DEFAULT_NOTE_TYPE

var skin:String = 'base'

var wasHit = false
var wasMissed = false
func canHit() -> bool:
	return false
func tooLate() -> bool:
	return true

func _init(_strum:Strum, _mania:int, _time:float):
	strum = _strum
	local_mania = _mania
	time = _time

func _ready():
	texture = load(Paths.image('arrows/%s/note head' % skin))
	modulate = QuantUtil._unknownColor
	scale = Vector2(0.7, 0.7)
	transform.rotated_local(directionAngles[id % local_mania])
