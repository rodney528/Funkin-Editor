extends Node

## The way you wish to search for files.
enum SearchType {
	## Searches for base files and mods.
	NORMAL,
	## Searches for base files.
	MODLESS,
	## Searches based on raw pathing.
	RAW
}

## The assets folder path.
const ASSETS_FOLDER:String = 'res://assets/'
## The mods folder path.
const MODS_FOLDER:String = 'res://mods/'

func _extCheck(path:String, exts:Array[String]) -> String:
	if exts.size() < 0:
		#print('[Paths._extCheck] "%s"' % path)
		if exists(path, SearchType.RAW):
			return path
	else:
		for ext in exts:
			var lePath = '%s.%s' % [path, ext]
			#print('[Paths._extCheck] "%s"' % lePath)
			if exists(lePath, SearchType.RAW):
				return lePath
	return Global.NONE

## Returns a path.
func file(path:String, exts:Array[String] = [], searchType:SearchType = SearchType.NORMAL) -> String:
	#print('[Paths.file] "%s", %s, %s' % [path, exts, searchType])
	if searchType == SearchType.RAW:
		return _extCheck(path, exts)
	
	if searchType != SearchType.MODLESS:
		for folder in ResourceLoader.list_directory(MODS_FOLDER):
			if !folder.ends_with('/'): continue
			return _extCheck(MODS_FOLDER + folder + path, exts)
	
	return _extCheck(ASSETS_FOLDER + path, exts)

## Checks if a file exists.
func exists(path:String, searchType:SearchType = SearchType.NORMAL) -> bool:
	#print('[Paths.file] "%s", %s' % [path, searchType])
	if searchType == SearchType.RAW:
		#print('[Paths.exists] "%s"' % path)
		return ResourceLoader.exists(path)
	
	if searchType != SearchType.MODLESS:
		for folder in ResourceLoader.list_directory(MODS_FOLDER):
			if !folder.ends_with('/'): continue
			#print('[Paths.exists] "%s"' % [MODS_FOLDER + folder + path])
			if ResourceLoader.exists(MODS_FOLDER + folder + path):
				return true
	
	#print('[Paths.exists] "%s"' % [ASSETS_FOLDER + path])
	return ResourceLoader.exists(ASSETS_FOLDER + path)

## All images extensions.
const IMAGE_EXTS:Array[String] = ['png']
## All audio extensions.
const AUDIO_EXTS:Array[String] = ['ogg', 'wav']

## Returns the path of an image file.
func image(path:String, exts:Array[String] = IMAGE_EXTS, searchType:SearchType = SearchType.NORMAL) -> String:
	return file('images/%s' % path, exts, searchType)

## Returns the path of an audio file.
func audio(path:String, exts:Array[String] = AUDIO_EXTS, searchType:SearchType = SearchType.NORMAL) -> String:
	return file(path, exts, searchType)
	
## Returns the path of a song.
func music(path:String, exts:Array[String] = AUDIO_EXTS, searchType:SearchType = SearchType.NORMAL) -> String:
	return audio('music/%s' % path, exts, searchType)
## Returns the path of a sound.
func sound(path:String, exts:Array[String] = AUDIO_EXTS, searchType:SearchType = SearchType.NORMAL) -> String:
	return audio('sounds/%s' % path, exts, searchType)
