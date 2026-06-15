extends Node2D

func _ready():
	Global.bgMusic.playing = false

func _process(_delta:float):
	if Input.is_action_just_pressed('ui_cancel'):
		queue_free()
		get_tree().paused = false
		get_parent().get_node('currentsong').playing = false
		Global.startVolTween()
