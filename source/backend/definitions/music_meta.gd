class_name MusicMeta extends Resource
var name:String
var artist:String
var checkpoints:Array[CheckpointMeta]

func _to_string():
	return 'MusicMeta[name: "{name}", artist: "{artist}", checkpoints: {checkpoints}]'.format({'name': name, 'artist': artist, 'checkpoints': checkpoints})
