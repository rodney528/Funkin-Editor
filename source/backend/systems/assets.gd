## Contains shortcut functions for getting object information.
extends Node

## Returns parsed json data.
func json(path:String, searchType:Paths.SearchType = Paths.SearchType.NORMAL) -> Variant:
	var jsonPath = Paths.file(path, ['json'], searchType)
	var fileAccess = FileAccess.open(jsonPath, FileAccess.READ)
	if !fileAccess: return null
	return JSON.parse_string(fileAccess.get_as_text())
