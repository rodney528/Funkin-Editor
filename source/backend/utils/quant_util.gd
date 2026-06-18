extends Node

## List of quant indexes.
const list:Array[int] = [4, 8, 12, 16, 20, 24, 32, 48, 64, 96, 192]
## If the quant index chosen doesn't exist. 
const _unknownColor:Color = Color(0x606789ff)
## All possible quant colors.
const colors:Array[Color] = [
	Color(0xff3535ff),
	Color(0x536befff),
	Color(0xc24b99ff),
	Color(0x01e550ff),
	_unknownColor,
	Color(0xff7ad7ff),
	Color(0xffe83dff),
	Color(0x10ebffff),
	_unknownColor,
	_unknownColor,
]
