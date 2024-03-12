extends CanvasLayer

@onready var _retry_button: Button = %Retry
@onready var _exit_button: Button = %ExitMainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _retry_button.pressed.connect(_restart_level): printerr("Fail: ",get_stack())
	if _exit_button.pressed.connect(exit_main_menu): printerr("Fail: ",get_stack())
	
func _restart_level()->void:
	get_tree().reload_current_scene()
	queue_free()

func exit_main_menu()->void:
	LevelManager.load_level("res://levels/game/main_menu.tscn")
