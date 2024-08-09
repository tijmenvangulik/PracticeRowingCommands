extends AnimatedSprite


class_name BladeSplash

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var waveCounter=0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func startSplash(flip):
	var wave=$"."
	if flip:
		rotation_degrees=0
	else:
		rotation_degrees=180
	wave.play()
	
	if !visible:
		visible=true
	

func _on_BladeSplash_animation_finished():
	visible=false
	var wave=$"."
	wave.stop()
