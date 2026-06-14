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
		var lastBpm = 100
		for checkpoint in meta.get('checkpoints', []):
			lastBpm = checkpoint.get('bpm', lastBpm)
			checkpoints.append(CheckpointMeta.new(lastBpm, checkpoint.get('time', INF), checkpoint.get('signature', [4, 4])))
		checkpoints.sort_custom(func(a, b): return a.time < b.time)

func _to_string() -> String:
	return 'MusicMeta(Song Name: "%s", Artist: "%s", Initial Checkpoint: %s)' % [name, artist, checkpoints[0]]
