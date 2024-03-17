class_name  GameLevel
extends Node

signal current_limit_changed(value:int)
signal next_limit_changed(value:int)

@export var limits: Array[int] = [150,300,600,1200,1600,3200,6400,10000]

@onready var _score_ui: ScoreUI = %ScoreUI
@onready var food_spawners_collection: Node = %FoodSpawners
@onready var _player_ref: Player = %Player
var _is_win: bool = false
var _current_limit : int = limits[0]:
	set(value):
		current_limit_changed.emit(value)
		_current_limit = value
var _next_limit: int = limits[1]:
	set(value):
		next_limit_changed.emit(value)
		_next_limit = value
var _index_of_current_limit: int = 1
var food_ps: PackedScene = preload("res://scenes/items/food.tscn")

func _ready() -> void:
	GigaSoundManager.music.play()
	if Score.score_changed.connect(_update_current_points): printerr("Fail: ",get_stack())
	if (self as Node).tree_exited.connect(_on_exit): printerr("Fail: ",get_stack())
	_score_ui.set_limits(_current_limit,_next_limit)
	for i: Marker2D in food_spawners_collection.get_children():
		var chance_to_spawn: int = randi_range(0,4)
		if( chance_to_spawn == 4):
			var food: Food = food_ps.instantiate() as Food
			i.add_child(food)
			food.global_position =  i.global_position

func _update_current_points(_value: int)->void:
	if(_is_win == false):
		if(_index_of_current_limit+2 > limits.size() and Score.score >= _current_limit ):
			LevelManager.load_level("res://levels/game/win_window.tscn")
			_is_win = true
		elif(_index_of_current_limit+3 > limits.size() and Score.score >= _current_limit ):
			_current_limit = limits[_index_of_current_limit+1]
			_next_limit = 0
			_score_ui.set_limits(_current_limit,_next_limit)
			_index_of_current_limit+=1
			Score.score = 0
			_player_ref.show_parasite()
		elif( Score.score >= _current_limit):
			_current_limit = limits[_index_of_current_limit+1]
			_next_limit = limits[_index_of_current_limit+2]
			_score_ui.set_limits(_current_limit,_next_limit)
			_index_of_current_limit+=1
			Score.score = 0
			_player_ref.show_parasite()
		
func _on_exit()->void:
	GigaSoundManager.music.stop()
