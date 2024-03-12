class_name Enemy
extends CharacterBody2D



@export var export_speed: float = 100.0


@export var _self: CharacterBody2D
@export var _silliness_sprite: Sprite2D
@export var _enemy_sprite: Sprite2D 


var peculiarities: RPeculiarities = RPeculiarities.new()

var _player_ref: Player
#divide by two because we are using both move_and_collide to return data about collision and move_and_slide to slide
var _speed: float = export_speed/2


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
	_silliness_sprite.texture = peculiarities.silliness_texture

func _physics_process(delta: float) -> void:
	if(_player_ref!=null):
		velocity = _speed * _self.global_position.direction_to(_player_ref.global_position)
	else:
		velocity = Vector2.ZERO
	var collide_data: KinematicCollision2D = move_and_collide(velocity*delta)
	if(collide_data != null and collide_data.get_collider() is Player):
		var player_peculiarities: RPeculiarities = (collide_data.get_collider() as Player).peculiarities
		if(peculiarities.color == player_peculiarities.color and peculiarities.silliness_texture == player_peculiarities.silliness_texture):
			Score.score+=25
			destroy_self()
		elif(peculiarities.color == player_peculiarities.color or peculiarities.silliness_texture == player_peculiarities.silliness_texture):
			(collide_data.get_collider() as Player).execute_slow_penalty()
			Score.score+=10
			destroy_self()
		else:
			(collide_data.get_collider() as Player)._health-=25
			destroy_self()
	move_and_slide()

func destroy_self()->void:
	queue_free()
