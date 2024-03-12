extends Node

@onready var _play_button: Button = %PlayButton

func _ready() -> void:
	if _play_button.connect("pressed", _on_pressed_play_button): printerr("Fail: ",get_stack()) 


func _on_pressed_play_button()->void:
	LevelManager.load_level("res://levels/game/game_level.tscn")
