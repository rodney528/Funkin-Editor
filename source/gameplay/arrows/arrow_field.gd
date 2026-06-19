class_name ArrowField extends Node2D

var conductor:Conductor
var charter:bool
var count:int

#var grid
var strums:Node = Node.new()
var notes:Node = Node.new()

func _init(_conductor:Conductor, _count:int, _charter:bool = false):
	conductor = _conductor
	charter = _charter
	count = _count

func _ready():
	generateStrums()
	add_child(strums)
	add_child(notes)

func generateStrums():
	for strum in strums.get_children():
		strums.remove_child(strum)
		strum.queue_free()
	for i in range(count):
		var strum = Strum.create(i)
		strum.transform.rotated_local(Note.directionAngles[i])
		strums.add_child(strum)
func generateNotes(time:float = -INF):
	if charter: time = -INF # prevents it from eating your progress
	if time < conductor.time: pass
