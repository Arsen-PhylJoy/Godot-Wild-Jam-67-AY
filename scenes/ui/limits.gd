class_name ScoreUI
extends CanvasLayer

@onready var _current_points:Label = %CurrentPoints
@onready var _current_limit:Label = %CurrentLimit
@onready var _next_limit:Label = %NextLimit


func _ready() -> void:
	if Score.score_changed.connect(_update_current_points): printerr("Fail: ",get_stack())

func _update_current_points(value: int)->void:
	_current_points.text = str(value)
	
func set_limits(new_limit: int, next_limit:int)->void:
	_current_points.text = str(0)
	_current_limit.text = str(new_limit)
	_next_limit.text = str(next_limit)
	if(next_limit == 0):
		_next_limit.text = "WIN"
