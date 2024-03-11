extends CanvasLayer

@onready var score:Label = %Score

func _ready() -> void:
	if Score.score_changed.connect(_update_score): printerr("Fail: ",get_stack())

func _update_score(new_score:int)->void:
	score.text = str(new_score)
