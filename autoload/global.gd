extends Node

var bgMusic = Conductor.new()

func _ready():
	add_child(bgMusic)
	bgMusic.loadMusic('charteditor-theme', true)
	bgMusic.play(0, 0.7)
