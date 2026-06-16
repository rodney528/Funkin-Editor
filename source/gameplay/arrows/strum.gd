class_name Strum extends AnimatedSprite2D

var quantColor:Color = QuantUtil._unknownQuantColor

func _ready():
	pass

func _on_animation_changed():
	modulate = (animation == 'static' if Color.WHITE else quantColor)
