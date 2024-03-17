class_name Player
extends CharacterBody2D

signal health_changed(max_health: float,current_health:float)
signal ability_changed(max_ability: float,current_ability:float)

@export var export_speed: float = 150.0
@export var export_health: float = 100.0

@onready var _silliness_sprite_hat: Sprite2D = %SillyHat
@onready var _silliness_sprite_eyes: Sprite2D = %SillyEyes
@onready var _silliness_sprite_moustache: Sprite2D = %SillyMoustache
@onready var _player_sprite: Sprite2D = %PlayerSprite
@onready var _anim_player: AnimationPlayer = %AnimationPlayer
@onready var _anim_player_ability: AnimationPlayer = %AbilityAnimationPlayer
@onready var _speed: float = export_speed
@onready var _health: float = export_health:
	set(value):
		if( value <= _health and _is_invulnerable ):
			return
		_health = value
		health_changed.emit(export_health,_health)
		if(value <= 0):
			Score.score = 0
			GigaSoundManager.lose.play()
			LevelManager.load_level("res://levels/game/main_menu.tscn")
@onready var ability_charge: float = 0:
	set(value):
		if(value>=100):
			_anim_player_ability.play("ready")
			ability_charge = 100
		if(value<0 or _is_invulnerable):
			return
		ability_charge = value
		ability_changed.emit(100,value)
		
var _has_slow_penalty: bool = false
var peculiarities: RPeculiarities = RPeculiarities.new()
var _is_invulnerable: bool = false

func _ready() -> void:
	_health = export_health
	ability_charge = 0.0
	($PlayerUI as CanvasLayer).show()
	peculiarities.color = peculiarities.EColor.BLUE
	_player_sprite.modulate = Color(0.459, 0.482, 1)
	peculiarities.silliness = peculiarities.ESilliness.HAT
	_silliness_sprite_hat.visible = true

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
		if(!_is_invulnerable):
			peculiarities.next_silliness()
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
	if Input.is_action_just_pressed("ability_use"):
		if(ability_charge >= 100):
			use_ability()

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Move_Up"):
		velocity.y-=1
	if Input.is_action_pressed("Move_Down"):
		velocity.y=1
	if Input.is_action_pressed("Move_Left"):
		_anim_player.play("movement_left")
		flip_parasites(false)
		velocity.x-=1
	if Input.is_action_pressed("Move_Right"):
		_anim_player.play("movement_right")
		flip_parasites(true)
		velocity.x=1
	if (velocity == Vector2.ZERO):
		_anim_player.stop()
		run_parasites(false)
	else:
		if(_anim_player.is_playing() == false):
			_anim_player.play("movement_right")
		run_parasites(true)
	@warning_ignore("unused_variable")
	var collide_data: KinematicCollision2D = move_and_collide(velocity.normalized()*_speed*delta)
	
func execute_slow_penalty()->void:
	if(_is_invulnerable):
		return
	_has_slow_penalty = true
	_speed/=2
	await get_tree().create_timer(2.0).timeout
	_has_slow_penalty = false
	_speed = export_speed

func use_ability()->void:
	GigaSoundManager.power_up.play()
	_anim_player_ability.play("fading_out")
	ability_charge = 0
	_is_invulnerable = true
	_silliness_sprite_hat.visible = true
	_silliness_sprite_eyes.visible = true
	_silliness_sprite_moustache.visible = true
	_player_sprite.modulate = Color.GOLD
	_speed*=3
	await get_tree().create_timer(3.0).timeout
	GigaSoundManager.power_up.stop()
	_speed = export_speed
	_is_invulnerable = false
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
	if(peculiarities.color == peculiarities.EColor.RED):
		_player_sprite.modulate = Color(1, 0.482, 0.459)
	elif(peculiarities.color == peculiarities.EColor.BLUE):
		_player_sprite.modulate = Color(0.459, 0.482, 1)
	elif(peculiarities.color == peculiarities.EColor.GREEN):
		_player_sprite.modulate = Color(0.459, 1, 0.482)


#These functions for parasites
func show_parasite()->void:
	export_speed+=12.5
	_speed+=12.5
	(%AnimationPlayerSpeedUP as AnimationPlayer).play("show_speed_up_label")
	for i: AnimatedSprite2D in %SmallParasites.get_children():
		if(i.visible == false):
			i.visible = true
			break

func flip_parasites(to_right: bool)->void:
	for i: AnimatedSprite2D in %SmallParasites.get_children():
		if(to_right == false):
			i.flip_h = false
		elif(to_right == true):
			i.flip_h = true

func run_parasites(do_run:bool)->void:
	for i: AnimatedSprite2D in %SmallParasites.get_children():
		if(do_run):
			i.play("Move")
		else:
			i.stop()
			
#End functions for parasites
