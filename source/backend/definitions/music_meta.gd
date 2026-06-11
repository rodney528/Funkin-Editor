class_name MusicMeta extends Resource

## The song id / folder name.
var id:String

## The name of the song.
var name:String
## The person (or people) who composed the song.
var artist:String
## The list of time changes in the song.
var checkpoints:Array[CheckpointMeta]

func _init(_id:String):
	var meta:Variant = JSON.parse_string(FileAccess.open(Paths.music('%s/audio' % _id, ['json']), FileAccess.READ).get_as_text())
	if meta:
		id = _id
		name = meta.get('name', _id)
		artist = meta.get('artist', 'UNKNOWN')
		checkpoints = []
		for checkpoint in meta.get('checkpoints', []):
			var lol = CheckpointMeta.new()
			lol.time = checkpoint.get('time', 0)
			lol.bpm = checkpoint.get('bpm', 100)
			lol.signature = checkpoint.get('signature', [4, 4])
			checkpoints.append(lol)
		checkpoints.sort_custom(func(a, b): return a.time < b.time)

func _to_string():
	return 'MusicMeta(name: "%s", artist: "%s", init checkpoint: %s)' % [name, artist, checkpoints[0]]
