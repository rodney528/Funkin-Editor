class_name ArrowField extends Node2D

var charter:bool
var count:int

#var grid
var strums:Node
var notes:Node

func _init(_count:int, _charter:bool = false):
	charter = _charter
	count = _count

func _ready():
	strums = Node.new()
	notes = Node.new()
	
	generateStrums()
	
	add_child(strums)
	add_child(notes)

func generateStrums():
	for strum in strums:
		print(strum)
	for i in range(count):
		Strum.create(i)

func generateNotes(time:float = -INF):
	if charter: time = -INF # prevents it from eating your progress
