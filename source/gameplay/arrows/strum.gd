class_name Strum extends AnimatedSprite2D

var field:ArrowField

var id:int

var quantColor:Color = QuantUtil._unknownColor

static var _create_id:int = 0
static func create(_id:int) -> Strum:
	_create_id = _id
	return load('res://source/gameplay/arrows/strum.tscn').instantiate()

func _ready():
	id = _create_id

func _on_animation_changed():
	match animation: # allows press to be colorized without effecting void press
		'static': modulate = Color.WHITE
		'confirm': modulate = quantColor
