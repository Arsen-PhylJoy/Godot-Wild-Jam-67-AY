extends CanvasLayer

@onready var _player: Player = $".."
@onready var _health_bar: TextureProgressBar = %Health

func _ready() -> void:
	if _player.health_changed.connect(_update_health_bar): printerr("Fail: ",get_stack())

func _update_health_bar(max_health: float,current_health:float)->void:
	_health_bar.max_value = max_health
	_health_bar.value = current_health
