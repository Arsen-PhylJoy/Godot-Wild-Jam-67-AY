class_name RPeculiarities
extends Resource

enum EColor {RED, BLUE, GREEN}
enum ESilliness {HAT,EYES,MOUSTACHE}

@export var color: EColor:
	set(value):
		color = value
	get:
		return color
@export var silliness: ESilliness:
	set(value):
		if(value == ESilliness.HAT or value == ESilliness.EYES or value == ESilliness.MOUSTACHE):
			silliness = value 
	get:
		return silliness

func next_color()->void:
	if(color == EColor.RED):
		color = EColor.BLUE
	elif(color == EColor.BLUE):
		color = EColor.GREEN
	elif(color == EColor.GREEN):
		color = EColor.RED
	
func next_silliness()->void:
	if(silliness == ESilliness.HAT):
		silliness = ESilliness.EYES
	elif(silliness == ESilliness.EYES):
		silliness = ESilliness.MOUSTACHE
	elif(silliness == ESilliness.MOUSTACHE):
		silliness = ESilliness.HAT

func randomize_peculiarities()->void:
	var color_array: Array[EColor] = [EColor.RED,EColor.BLUE,EColor.GREEN]
	var pec_array: Array[ESilliness] = [ESilliness.HAT, ESilliness.EYES, ESilliness.MOUSTACHE]
	color =  color_array.pick_random()
	silliness = pec_array.pick_random()
