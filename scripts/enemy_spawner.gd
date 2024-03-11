class_name EnemySpawner
extends Node

@export var _player_ref: Player

var enemy_ps: PackedScene = preload("res://scenes/enemy/enemy.tscn")

var _can_create_enemies: bool = true

func _process(_delta: float) -> void:
	create_enemies()

func create_enemies()->void:
	if(!_can_create_enemies):
		return
	_spawm_enemies()
	_can_create_enemies = false
	await get_tree().create_timer(4.5).timeout
	_can_create_enemies = true
	
	
func _spawm_enemies()->void:
	if(_player_ref == null):
		return
	for i: int in 5:
		var enemy: Enemy = enemy_ps.instantiate() as Enemy
		$".".add_child(enemy)
		enemy.global_position = generate_random_position_on_rectangle(get_window().size)
		enemy.scale*=4
	
func generate_random_position_on_rectangle(size : Vector2)->Vector2:
	var side: int = randi_range(0, 3)
	var x : float 
	var y : float 
	if side == 0:
		x = randf_range(0, size.x)
		y = size.y
	elif side == 1:
		x = size.x
		y = randf_range(0, size.y)
	elif side == 2:
		x = randf_range(0, size.x)
		y = 0
	elif side == 3:
		x = 0
		y = randf_range(0, size.y)
	
	return Vector2(x+140, y+140)
