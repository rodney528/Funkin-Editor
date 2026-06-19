## This class handles all extra key related information.
extends Node

const MIN_KEYS = 1 ## The minimum amount of keys.
const MAX_KEYS = 9 ## The maximum amount of keys.

const L = 0 ## 0 = Left
const D = 1 ## 1 = Down
const U = 2 ## 2 = Up
const R = 3 ## 3 = Right

## Contains data for all possible keycounts.
var _countData:Dictionary[int, KeyCountData] = {
	1: KeyCountData.new(1, [U]),
	2: KeyCountData.new(2, [L, R]),
	3: KeyCountData.new(3, [L, U, R]),
	4: KeyCountData.new(4, [L, D, U, R]),
	5: KeyCountData.new(5, [L, D, U, U, R]),
	6: KeyCountData.new(6, [L, U, R, L, D, R]),
	7: KeyCountData.new(7, [L, U, R, U, L, D, R]),
	8: KeyCountData.new(8, [L, D, U, R, L, D, U, R]),
	9: KeyCountData.new(9, [L, D, U, R, U, L, D, U, R])
}

## Returns keycount data of your choosing. If less then `MIN_KEYS` or more then `MAX_KEYS`, this will return null!
func getData(count:int) -> KeyCountData:
	if count < MIN_KEYS: print('[KeyCountUtil.getData] %s is less than MIN_KEYS (%s), returning null.' % [count, MIN_KEYS]); return null
	if count > MAX_KEYS: print('[KeyCountUtil.getData] %s is greater than MAX_KEYS (%s), returning null.' % [count, MAX_KEYS]); return null
	return _countData[count]

## Wraps an index around the total length of "count". If less then `MIN_KEYS` or more then `MAX_KEYS`, this will return the input!
func wrap(input:int, count:int) -> int:
	if count < MIN_KEYS: print('[KeyCountUtil.wrap] %s is less than MIN_KEYS (%s), returning currnet input.' % [input, MIN_KEYS]); return input
	if count > MAX_KEYS: print('[KeyCountUtil.wrap] %s is greater than MAX_KEYS (%s), returning current input.' % [input, MAX_KEYS]); return input
	return getData(count).wrap(input)

class KeyCountData extends Node:
	var count:int
	var converts:Array[int]

	func _init(_count:int, _converts:Array[int]):
		count = _count
		if _converts.size() != count:
			print('[KeyCountData.new] Count %s converts array has an incorrect size.' % count)
		converts = _converts
	
	## Wraps an index around the total length of "count".
	func wrap(input:int) -> int:
		return wrapi(input, 0, count - 1)
	
	func _to_string() -> String:
		return 'KeyCountData(Count: %s)' % count
