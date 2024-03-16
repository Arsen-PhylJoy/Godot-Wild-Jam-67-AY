class_name  Food
extends Area2D

@export var heal_amount: float = 25

func _ready() -> void:
	if (self as Area2D).body_entered.connect(_player_entered) : printerr("Fail: ",get_stack())

func _player_entered(node: Node2D)->void:
	if(node is Player):
		(node as Player)._health+=heal_amount
	queue_free()
	
