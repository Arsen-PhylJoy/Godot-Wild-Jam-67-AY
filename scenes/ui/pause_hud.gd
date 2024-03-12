extends CanvasLayer


@onready var _continue_button: Button = %Continue

func _ready() -> void:
	(self as CanvasLayer).process_mode = Node.PROCESS_MODE_ALWAYS
	if (self as Node).tree_exiting.connect(_on_free): printerr("Fail: ",get_stack())
	if _continue_button.pressed.connect(_on_continue_pressed): printerr("Fail: ",get_stack())
	get_tree().paused = true

func _on_continue_pressed()->void:
	get_tree().paused = false
	queue_free()

func _on_free()->void:
	get_tree().paused = false
