extends Node

signal current_limit_changed(value:int)
signal next_limit_changed(value:int)

@export var limits: Array[int] = [200,400,800,1600,3200,6400,10000]

@onready var _score_ui: ScoreUI = %ScoreUI

var _current_limit : int = limits[0]:
	set(value):
		current_limit_changed.emit(value)
		_current_limit = value
var _next_limit: int = limits[1]:
	set(value):
		next_limit_changed.emit(value)
		_next_limit = value
var _index_of_current_limit: int = 0

func _ready() -> void:
	if Score.score_changed.connect(_update_current_points): printerr("Fail: ",get_stack())

func _update_current_points(value: int)->void:
	if(_index_of_current_limit+1 > limits.size() and Score.score >= _current_limit ):
		LevelManager.load_level("res://levels/game/main_menu.tscn")
	elif(_index_of_current_limit+2 > limits.size() and Score.score >= _current_limit ):
		_current_limit = limits[_index_of_current_limit+1]
		_next_limit = 0
		_score_ui.set_limits(_current_limit,_next_limit)
		_index_of_current_limit+=1
		Score.score = 0
	elif( Score.score >= _current_limit):
		_current_limit = limits[_index_of_current_limit+1]
		_next_limit = limits[_index_of_current_limit+2]
		_score_ui.set_limits(_current_limit,_next_limit)
		_index_of_current_limit+=1
		Score.score = 0
		
