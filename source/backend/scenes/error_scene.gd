class_name ErrorScene extends Scene2D

const _headerText:String = '{[ ERROR SCENE MESSAGE ]}'
static var inputText:String = 'Set this text upon launching the scene.'
func resultText() -> String: return '%s\n\n%s' % [_headerText, inputText]

func _process(_delta:float):
	if $errorTxt.text != resultText():
		$errorTxt.text = resultText()
