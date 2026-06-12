class_name Paths extends Node

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
static var ASSETS_FOLDER:String = 'res://assets/'
## The mods folder path.
static var MODS_FOLDER:String = 'res://mods/'

static func _static_init():
	pass

static func _extCheck(path:String, exts:Array[String]) -> String:
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
	return '[NONE]'

static func file(path:String, exts:Array[String] = [], searchType:SearchType = SearchType.NORMAL) -> String:
	#print('[Paths.file] "%s", %s, %s' % [path, exts, searchType])
	if searchType == SearchType.RAW:
		return _extCheck(path, exts)
	
	if searchType != SearchType.MODLESS:
		for folder in ResourceLoader.list_directory(MODS_FOLDER):
			if !folder.ends_with('/'): continue
			return _extCheck(MODS_FOLDER + folder + path, exts)
	
	return _extCheck(ASSETS_FOLDER + path, exts)

static func exists(path:String, searchType:SearchType = SearchType.NORMAL) -> bool:
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

static var IMAGE_EXTS:Array[String] = ['png']
static func image(path:String, exts:Array[String] = IMAGE_EXTS, searchType:SearchType = SearchType.NORMAL) -> String:
	return file('images/%s' % path, exts, searchType)

static var AUDIO_EXTS:Array[String] = ['ogg', 'wav']
static func music(path:String, exts:Array[String] = AUDIO_EXTS, searchType:SearchType = SearchType.NORMAL) -> String:
	return file('music/%s' % path, exts, searchType)
static func sound(path:String, exts:Array[String] = AUDIO_EXTS, searchType:SearchType = SearchType.NORMAL) -> String:
	return file('sounds/%s' % path, exts, searchType)
