class_name MusicMeta extends Resource

## The song id / folder name.
var id:String

## The name of the song.
@export var name:String
## The person (or people) who composed the song.
@export var artist:String = 'UNKNOWN'
## The list of time changes in the song.
@export var checkpoints:Array[CheckpointMeta] = []

static func create(_id:String) -> MusicMeta:
	#var tresMeta = load(Paths.music('%s/audio' % _id, ['tres'])); if tresMeta: return tresMeta
	var jsonPath = Paths.music('%s/audio' % _id, ['json'])
	var fileAccess = FileAccess.open(jsonPath, FileAccess.READ)
	if !fileAccess: return load(Paths.music('%s/audio' % _id, ['tres']))
	var data:Variant = JSON.parse_string(fileAccess.get_as_text())
	if data:
		var meta = MusicMeta.new()
		meta.id = _id
		meta.name = data.get('name', _id)
		meta.artist = data.get('artist', meta.artist)
		var lastBpm = 100
		for checkpoint in data.get('checkpoints', []):
			lastBpm = checkpoint.get('bpm', lastBpm)
			meta.checkpoints.append(CheckpointMeta.new(lastBpm, checkpoint.get('time', INF), checkpoint.get('signature', [4, 4])))
		meta.checkpoints.sort_custom(func(a, b): return a.time < b.time)
		return meta
	return null

func _to_string() -> String:
	return 'MusicMeta(Song Name: "%s", Artist: "%s", Initial Checkpoint: %s)' % [name, artist, checkpoints[0]]
