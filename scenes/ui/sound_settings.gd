extends Control

@export var db_coefficient: float = 75.0
@onready var _master_slider: HSlider = %MasterHSlider
@onready var _music_slider: HSlider = %MusicHSlider
@onready var _sfx_slider: HSlider = %SFXHSlider
@onready var _master_bus_id: int = AudioServer.get_bus_index("Master")
@onready var _music_bus_id: int = AudioServer.get_bus_index("Music")
@onready var _sfx_bus_id: int = AudioServer.get_bus_index("SFX")
var _music_on: bool = true
var _sfx_on: bool = true

func _ready() -> void:
	if _master_slider.value_changed.connect(_on_master_value_changed) : printerr("Fail: ",get_stack())
	if _music_slider.value_changed.connect(_on_music_value_changed) : printerr("Fail: ",get_stack())
	if _sfx_slider.value_changed.connect(_on_sfx_value_changed) : printerr("Fail: ",get_stack())
	_master_slider.value = Settings.master_volume
	_music_slider.value = Settings.music_volume
	_sfx_slider.value = Settings.sfx_volume


func _on_master_value_changed(value:float)->void:
	Settings.master_volume = value
	AudioServer.set_bus_volume_db(_master_bus_id,linear_to_db(value/db_coefficient))
	AudioServer.set_bus_mute(_master_bus_id,value<0.05)


func _on_music_value_changed(value:float)->void:
	Settings.music_volume = value
	if(_music_on == false and value<0.05):
		return
	_music_on = true	
	AudioServer.set_bus_volume_db(_music_bus_id,linear_to_db(value/db_coefficient))
	AudioServer.set_bus_mute(_music_bus_id,value<0.05)
		
func _on_sfx_value_changed(value:float)->void:
	Settings.sfx_volume = value
	if(_sfx_on == false and value<0.05):
		return
	_sfx_on = true	
	AudioServer.set_bus_volume_db(_sfx_bus_id,linear_to_db(value/db_coefficient))
	AudioServer.set_bus_mute(_sfx_bus_id,value<0.05)

