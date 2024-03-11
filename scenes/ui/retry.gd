extends CanvasLayer

@onready var _retry_button: Button = %retry

var level: PackedScene = preload("res://levels/level_test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _retry_button.pressed.connect(_load_new_level): printerr("Fail: ",get_stack())

func _load_new_level()->void:
	get_tree().reload_current_scene()
	queue_free()
