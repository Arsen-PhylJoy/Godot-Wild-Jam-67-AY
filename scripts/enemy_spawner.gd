class_name EnemySpawner
extends Node

@export var player_ref: Player
@export var allow_spawn_area: Area2D
var enemies_to_spawn: int = 5
var chance_to_spawn_speed_enemy: int = 1
var enemies_ps: Array[PackedScene] = [  preload("res://scenes/enemy/medicines/medicine_1.tscn"),
										preload("res://scenes/enemy/medicines/medicine_2.tscn"),
										preload("res://scenes/enemy/medicines/medicine_3.tscn"),
										preload("res://scenes/enemy/medicines/medicine_4.tscn")  ]

var _can_create_enemies: bool = true
var _creation_timer: Timer

func _ready() -> void:
	_creation_timer = Timer.new()
	add_child(_creation_timer)
	_creation_timer.wait_time = 4.5
	_creation_timer.start()
	if _creation_timer.timeout.connect(create_enemies) : printerr("Fail: ",get_stack())
	if (get_parent() as GameLevel).current_limit_changed.connect(_on_limit_changed) : printerr("Fail: ",get_stack())

func create_enemies()->void:
	if(!_can_create_enemies):
		return
	_spawm_enemies()
	_can_create_enemies = false
	await get_tree().create_timer(4.5).timeout
	_can_create_enemies = true
	
	
func _spawm_enemies()->void:
	if(player_ref == null):
		return
	for i: int in enemies_to_spawn:
		var enemy: Enemy = (enemies_ps.pick_random() as PackedScene).instantiate() as Enemy
		$".".add_child(enemy)
		enemy.rewarded.connect((%ComboLabels as ComboSys)._calculate)
		enemy.global_position = generate_random_position_on_rectangle(get_window().size * randf_range(1.1,1.3))
		if(randi_range(0,100) <= chance_to_spawn_speed_enemy):
			enemy._speed*=2.5

func generate_random_position_on_rectangle(size : Vector2)->Vector2:
	var top_left: Vector2 = Vector2(player_ref.global_position.x - size.x/2, player_ref.global_position.y - size.y/2)
	var top_right: Vector2 = Vector2(player_ref.global_position.x + size.x/2, player_ref.global_position.y - size.y/2)
	var bottom_left: Vector2 = Vector2(player_ref.global_position.x - size.x/2, player_ref.global_position.y + size.y/2)
	var bottom_right: Vector2 = Vector2(player_ref.global_position.x + size.x/2, player_ref.global_position.y + size.y/2)
	var spawn_pos_1:Vector2 = Vector2.ZERO
	var spawn_pos_2:Vector2 = Vector2.ZERO
	var spawn_point: Vector2 = Vector2(-10000.0,-10000.0)
	while (!(allow_spawn_area.get_child(0) as CollisionShape2D).shape.get_rect().has_point(spawn_point)):
		var pos_side: int = [0,1,2,3].pick_random()
		match pos_side:
			0:
				spawn_pos_1 = top_left
				spawn_pos_2 = top_right
			1:
				spawn_pos_1 = bottom_left
				spawn_pos_2 = bottom_right
			2:
				spawn_pos_1 = top_right
				spawn_pos_2 = bottom_right
			3:
				spawn_pos_1 = top_left
				spawn_pos_2 = bottom_left
		spawn_point.x = randf_range(spawn_pos_1.x,spawn_pos_2.x)
		spawn_point.y = randf_range(spawn_pos_1.y,spawn_pos_2.y)
	return Vector2(spawn_point)

func _on_limit_changed(_value:int)->void:
	if(chance_to_spawn_speed_enemy<=15):
		chance_to_spawn_speed_enemy+=2
	if(enemies_to_spawn<=8):
		enemies_to_spawn+=1
