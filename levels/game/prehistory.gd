extends Node

@onready var _menu_button: Button = %Continue

func _ready() -> void:
	if _menu_button.connect("pressed", _on_pressed_continue_button): printerr("Fail: ",get_stack()) 


func _on_pressed_continue_button()->void:
	LevelManager.load_level("res://levels/game/main_menu.tscn")
