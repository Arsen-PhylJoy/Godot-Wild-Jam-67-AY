class_name RPeculiarities
extends Resource

enum EColor {RED, BLUE, GREEN}
const PEC1: CompressedTexture2D = preload("res://assets/graphic/not_release_assets/sillinesses/debug_pec_1.png")
const PEC2: CompressedTexture2D = preload("res://assets/graphic/not_release_assets/sillinesses/debug_pec_2.png")
const PEC3: CompressedTexture2D = preload("res://assets/graphic/not_release_assets/sillinesses/debug_pec_3.png")

@export var color: EColor:
	set(value):
		color = value
	get:
		return color
@export var silliness_texture: CompressedTexture2D:
	set(value):
		if(value == PEC1 or value == PEC2 or value == PEC3):
			silliness_texture = value 
	get:
		return silliness_texture

func next_color()->void:
	if(color == EColor.RED):
		color = EColor.BLUE
	elif(color == EColor.BLUE):
		color = EColor.GREEN
	elif(color == EColor.GREEN):
		color = EColor.RED
	
func next_silliness()->void:
	if(silliness_texture == PEC1):
		silliness_texture = PEC2
	elif(silliness_texture == PEC2):
		silliness_texture = PEC3
	elif(silliness_texture == PEC3):
		silliness_texture = PEC1

func randomize_peculiarities()->void:
	var color_array: Array[EColor] = [EColor.RED,EColor.BLUE,EColor.GREEN]
	var pec_array: Array[CompressedTexture2D] = [PEC1,PEC2,PEC3]
	color =  color_array.pick_random()
	silliness_texture = pec_array.pick_random()
