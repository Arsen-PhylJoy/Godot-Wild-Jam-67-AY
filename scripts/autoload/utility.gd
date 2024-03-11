extends Node
#It's temporar class

var _retry: PackedScene = preload("res://scenes/ui/retry.tscn")

func show_retry_button()->void:
	add_child(_retry.instantiate())
