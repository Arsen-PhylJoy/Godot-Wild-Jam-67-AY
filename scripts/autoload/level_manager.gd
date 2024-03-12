extends Node

signal transition_finished

var loading_screen:LoadingScreen
var _loading_screen_scene:PackedScene = preload("res://scenes/utility/loading_screen.tscn")
var _transition_name:String
var _level_scene:PackedScene

func _ready() -> void:
	print(get_tree().current_scene.name)
	
func load_level(level_path:String, transition_name:String="fade_to_black") -> void:
	_level_scene = load(level_path)
	_transition_name = transition_name
	_start_load_level()
	
func _start_load_level()-> void:
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	if(!loading_screen.transition_in_ended.is_connected(_on_transition_in_ended)):
		if loading_screen.transition_in_ended.connect(_on_transition_in_ended): printerr("Fail: ",get_path()) 
	loading_screen.start_transition(_transition_name)
	
func _end_load_level()-> void:
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_packed(_level_scene)
	transition_finished.emit()
	await loading_screen.finish_transition()

func _on_transition_in_ended()->void:
	_end_load_level()
