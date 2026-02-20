extends Node

signal game_recorded(result: int)  # 1 = win, -1 = loss, 0 = draw

var history: Array[int] = []
var cumulative: Array[int] = [0]

func record_game(result: int):
	history.append(result)
	var new_cum = cumulative.back() + result
	cumulative.append(new_cum)
	game_recorded.emit(result)
