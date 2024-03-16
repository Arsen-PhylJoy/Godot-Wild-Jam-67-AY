class_name Player
extends CharacterBody2D

signal health_changed(max_health: float,current_health:float)
	

@export var export_speed: float = 150.0
@export var export_health: float = 100.0

@onready var _silliness_sprite: Sprite2D = %Silliness
@onready var _player_sprite: Sprite2D = %PlayerSprite
@onready var _anim_player: AnimationPlayer = %AnimationPlayer
@onready var _speed: float = export_speed
@onready var _health: float = export_health:
	set(value):
		_health = value
		health_changed.emit(export_health,_health)
		if(value <= 0):
			Score.score = 0
			Utility.show_retry_button()
			queue_free()
var _has_slow_penalty: bool = false
var peculiarities: RPeculiarities = RPeculiarities.new()


func _ready() -> void:
	_health = export_health
	($PlayerUI as CanvasLayer).show()
	peculiarities.color = peculiarities.EColor.BLUE
	_player_sprite.modulate = Color(0.459, 0.482, 1)
	peculiarities.silliness_texture = peculiarities.PEC1
	_silliness_sprite.texture = peculiarities.silliness_texture

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_color"):
		peculiarities.next_color()
		if(peculiarities.color == peculiarities.EColor.RED):
			_player_sprite.modulate = Color(1, 0.482, 0.459)
		elif(peculiarities.color == peculiarities.EColor.BLUE):
			_player_sprite.modulate = Color(0.459, 0.482, 1)
		elif(peculiarities.color == peculiarities.EColor.GREEN):
			_player_sprite.modulate = Color(0.459, 1, 0.482)
	if Input.is_action_just_pressed("change_silliness"):
		peculiarities.next_silliness()
		_silliness_sprite.texture = peculiarities.silliness_texture

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Move_Up"):
		velocity.y-=1
	if Input.is_action_pressed("Move_Down"):
		velocity.y=1
	if Input.is_action_pressed("Move_Left"):
		_anim_player.play("movement_left")
		velocity.x-=1
	if Input.is_action_pressed("Move_Right"):
		_anim_player.play("movement_right")
		velocity.x=1
	if (velocity == Vector2.ZERO):
		_anim_player.stop()
	@warning_ignore("unused_variable")
	var collide_data: KinematicCollision2D = move_and_collide(velocity.normalized()*_speed*delta)
	
func execute_slow_penalty()->void:
	_has_slow_penalty = true
	_speed/=2
	await get_tree().create_timer(2.0).timeout
	_has_slow_penalty = false
	_speed = export_speed
