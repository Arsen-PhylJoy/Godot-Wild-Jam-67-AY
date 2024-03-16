class_name Enemy
extends CharacterBody2D

signal rewarded(reward: int)

@export var export_speed: float = 100.0
@export var big_reward: int = 25
@export var small_reward: int = 10
@export var _self: CharacterBody2D
@export var _enemy_sprite: Sprite2D 
@export var _silliness_sprite_hat: Sprite2D
@export var _silliness_sprite_eyes: Sprite2D 
@export var _silliness_sprite_moustache: Sprite2D


#divide by two because we are using both move_and_collide to return data about collision and move_and_slide to slide
@onready var _speed: float = export_speed/2

var _damage_multiplier: float = 1.0

var peculiarities: RPeculiarities = RPeculiarities.new()

var _player_ref: Player


func _ready() -> void:
	for node : Node in get_tree().current_scene.get_children():
		if( node is Player):
			_player_ref = node
	peculiarities.randomize_peculiarities()
	if(peculiarities.color == peculiarities.EColor.RED):
		_enemy_sprite.modulate = Color.RED
	elif(peculiarities.color == peculiarities.EColor.BLUE):
		_enemy_sprite.modulate = Color.BLUE
	elif(peculiarities.color == peculiarities.EColor.GREEN):
		_enemy_sprite.modulate = Color.GREEN
	if(peculiarities.silliness == peculiarities.ESilliness.HAT):
		_silliness_sprite_hat.visible = true
		_silliness_sprite_eyes.visible = false
		_silliness_sprite_moustache.visible = false
	if(peculiarities.silliness == peculiarities.ESilliness.EYES):
		_silliness_sprite_hat.visible = false
		_silliness_sprite_eyes.visible = true
		_silliness_sprite_moustache.visible = false
	if(peculiarities.silliness == peculiarities.ESilliness.MOUSTACHE):
		_silliness_sprite_hat.visible = false
		_silliness_sprite_eyes.visible = false
		_silliness_sprite_moustache.visible = true
	var mult: float =  randf_range(1.0,1.3)
	(self as CharacterBody2D).scale = Vector2(mult,mult)
	_damage_multiplier = mult

func _physics_process(delta: float) -> void:
	if(_player_ref!=null):
		velocity = _speed * _self.global_position.direction_to(_player_ref.global_position)
	else:
		velocity = Vector2.ZERO
	var collide_data: KinematicCollision2D = move_and_collide(velocity*delta)
	move_and_slide()
	if(collide_data != null and collide_data.get_collider() is Player):
		var player_peculiarities: RPeculiarities = (collide_data.get_collider() as Player).peculiarities
		if((collide_data.get_collider() as Player)._is_invulnerable):
			rewarded.emit(big_reward * _damage_multiplier)
			destroy_self()			
		elif(peculiarities.color == player_peculiarities.color and peculiarities.silliness == player_peculiarities.silliness):
			(collide_data.get_collider() as Player).ability_charge+=15
			rewarded.emit(big_reward * _damage_multiplier)
			destroy_self()
		elif(peculiarities.color == player_peculiarities.color or peculiarities.silliness == player_peculiarities.silliness):
			(collide_data.get_collider() as Player).execute_slow_penalty()
			(collide_data.get_collider() as Player).ability_charge+=5
			rewarded.emit(small_reward * _damage_multiplier)
			destroy_self()
		else:
			(collide_data.get_collider() as Player)._health-=(25.0*_damage_multiplier)
			rewarded.emit(0)
			destroy_self()

func destroy_self()->void:
	queue_free()
