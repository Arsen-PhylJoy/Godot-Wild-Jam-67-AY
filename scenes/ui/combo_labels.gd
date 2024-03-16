class_name ComboSys
extends CanvasLayer

enum _MULTIPLICATOR {X1 = 1,X2 = 2,X4 = 4,X8 = 8,X16 = 16}

@onready var _reward_label: Label = %RewardLabel
@onready var _x_progess_bar: ProgressBar = %XProgressBar
@onready var _gradient_update_timer: Timer = %GradientUpdateTimer
@onready var _multiplicator_animation_player: AnimationPlayer = %AnimationPlayerMultiplicator
@onready var _reward_labels_animation_player: AnimationPlayer = %AnimationPlayerRewardsLabels

var _multiplicator: _MULTIPLICATOR = _MULTIPLICATOR.X1
var _current_points: int = 0
var _points_to_next_x: int = 100

func _ready() -> void:
	if _x_progess_bar.value_changed.connect(_update_x_progress_bar): printerr("Fail: ",get_stack())
	if _gradient_update_timer.timeout.connect(_random_change_gradient_offsets): printerr("Fail: ",get_stack())
			
func _calculate(reward: int)->void:
	var result_reward:int = reward * _multiplicator
	_current_points+=result_reward
	if(result_reward != 0):
		Score.score+=result_reward
		_x_progess_bar.value = float(_current_points)/float(_points_to_next_x)*100
		print("_current_points: ", _current_points,"_result_reward: ", result_reward,"points_to_next: ", _points_to_next_x,)
		print(float(_current_points)/float(_points_to_next_x)*100)
	else:
		_current_points = 0
		_points_to_next_x = 100
		_lower_multiplicator()

func _update_x_progress_bar(new_value: float)->void:
	if(new_value>=100):
		_increase_multiplicator()
		_x_progess_bar.value = 25
	elif(new_value<=0):
		_lower_multiplicator()
		
func _lower_multiplicator()->void:
	_multiplicator = _MULTIPLICATOR.X1
	_points_to_next_x = 100
	_current_points = 0
	_update_animations()
	
func _increase_multiplicator()->void:
	if(_multiplicator == _MULTIPLICATOR.X1):
		_multiplicator = _MULTIPLICATOR.X2
		_points_to_next_x = 400
	elif(_multiplicator == _MULTIPLICATOR.X2):
		_multiplicator = _MULTIPLICATOR.X4
		_points_to_next_x = 1200
	elif(_multiplicator == _MULTIPLICATOR.X4):
		_multiplicator = _MULTIPLICATOR.X8
		_points_to_next_x = 3600
	elif(_multiplicator == _MULTIPLICATOR.X8):
		_multiplicator = _MULTIPLICATOR.X16
		_points_to_next_x = 7200
	elif(_multiplicator == _MULTIPLICATOR.X16):
		pass
	_update_animations()
	
func  _update_animations()-> void:
	if(_multiplicator != _MULTIPLICATOR.X1):
		if(_multiplicator == _MULTIPLICATOR.X2):
			_multiplicator_animation_player.play("X2")
			_reward_labels_animation_player.play("x2_reward_label")
		elif(_multiplicator == _MULTIPLICATOR.X4):
			_multiplicator_animation_player.play("X4")
			_reward_labels_animation_player.play("x4_reward_label")
		elif(_multiplicator == _MULTIPLICATOR.X8):
			_multiplicator_animation_player.play("X8")
			_reward_labels_animation_player.play("x8_reward_label")
		elif(_multiplicator == _MULTIPLICATOR.X16):
			_multiplicator_animation_player.play("X16")
			_reward_labels_animation_player.play("x16_reward_label")
	else:
		_multiplicator_animation_player.play("X1")

func _random_change_gradient_offsets()->void:
	var gradient: GradientTexture1D = (_reward_label.material.get("shader_parameter/gradient") as GradientTexture1D)
	for i: int in gradient.gradient.get_point_count():
		gradient.gradient.set_offset(i,gradient.gradient.get_offset(i)+randf_range(-0.05,0.05))
