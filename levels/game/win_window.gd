extends Node

@onready var _exit_button: Button = %Exit

func _ready() -> void:
	if _exit_button.pressed.connect(_exit): printerr("Fail: ",get_stack())
	GigaSoundManager.win.play()

func _exit()->void:
	LevelManager.load_level("res://levels/game/main_menu.tscn")
