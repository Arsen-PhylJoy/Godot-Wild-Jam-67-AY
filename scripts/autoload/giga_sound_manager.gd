extends Node

var music: AudioStreamPlayer
var pop_bubbles_pool: AudioStreamRandomizer
var pop_bubble: AudioStreamPlayer
var power_up: AudioStreamPlayer
var lose: AudioStreamPlayer
var win: AudioStreamPlayer

func _ready() -> void:
	#Music
	music = AudioStreamPlayer.new()
	music.bus = "Music"
	music.stream = preload("res://assets/sound/happy.mp3")
	#
	#Pop Bubbles
	pop_bubbles_pool = AudioStreamRandomizer.new()
	pop_bubbles_pool.add_stream(0,preload("res://assets/sound/pop1.ogg"))
	pop_bubbles_pool.add_stream(1,preload("res://assets/sound/pop2.ogg"))
	pop_bubbles_pool.add_stream(2,preload("res://assets/sound/pop3.ogg"))
	pop_bubbles_pool.playback_mode = AudioStreamRandomizer.PLAYBACK_RANDOM
	pop_bubble = AudioStreamPlayer.new()
	pop_bubble.stream = pop_bubbles_pool
	pop_bubble.volume_db+=12.0
	pop_bubble.bus = "SFX"
	#
	#Power_up
	power_up = AudioStreamPlayer.new()
	power_up.bus = "SFX"
	power_up.stream = preload("res://assets/sound/power_up.mp3")
	#
	#lose
	lose = AudioStreamPlayer.new()
	lose.bus = "SFX"
	lose.stream = preload("res://assets/sound/lose.mp3")
	#
	#win
	win = AudioStreamPlayer.new()
	win.bus = "SFX"
	win.stream = preload("res://assets/sound/win.wav")
	#
	add_child(music)
	add_child(pop_bubble)
	add_child(power_up)
	add_child(lose)
	
