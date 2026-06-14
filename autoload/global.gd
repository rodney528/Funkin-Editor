extends Node

var bgMusic = Conductor.new()
var _music_vol_tween

func startVolTween():
	if _music_vol_tween: _music_vol_tween.stop()
	_music_vol_tween = create_tween().bind_node(self)
	bgMusic.volume = 0
	bgMusic.playing = true
	_music_vol_tween.tween_property(bgMusic, 'volume', 0.7, 1.3)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(bgMusic)
	bgMusic.loadMusic('charteditor-theme', true)
	bgMusic.play(0, 0.7)

## Joins an array into a string.
func joinArray(array:Array, joiner:String = ',') -> String:
	var result:String = ''
	for piece in array: result += '%s%s' % [piece, joiner]
	return result.trim_suffix(joiner)

func trimFloatDisplay(input:Variant) -> String:
	var _float:String
	if input is String: _float = input
	else: _float = str(input)
	
	if _float.contains('.'):
		var justZero:bool = true
		var digits = _float.get_slice('.', 1).split('.')
		for digit in digits:
			if digit != '0': justZero = false; break
		digits.clear()
		if justZero: return _float.get_slice('.', 0)
	return _float

## Rounds a decimal down to a specified amount.
func roundDecimal(value:float, precision:int, decimal_padding:int = 0) -> float:
	var mult:float = 1
	for i in range(0, precision): mult *= 10
	var result:float = roundf(value * mult) / mult
	if decimal_padding < 0: return result
	return float('%s.%s' % [str(result).get_slice('.', 0), str(result).get_slice('.', 1).pad_zeros(decimal_padding)])

## Converts seconds into displayed time.
func toDisplayTime(time:float, millisecondPrecision:int = 0) -> String:
	var data = Time.get_time_dict_from_unix_time(floori(time));
	var strOutput:String = ''
	if data['hour'] != 0:
		strOutput += str(data['hour']).pad_zeros(2)
		strOutput += ':'
	if strOutput.is_empty(): strOutput += str(data['minute'])
	else: strOutput += str(data['minute']).pad_zeros(2)
	strOutput += ':'
	strOutput += str(data['second']).pad_zeros(2)
	if millisecondPrecision > 0:
		strOutput += '.'
		strOutput += str(time).get_slice('.', 1).left(millisecondPrecision).pad_zeros(millisecondPrecision)
	return strOutput
