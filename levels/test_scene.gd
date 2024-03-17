extends Node


func  _process(delta: float) -> void:
	if(($AudioStreamPlayer as AudioStreamPlayer).playing == false):
		($AudioStreamPlayer as AudioStreamPlayer).play()
