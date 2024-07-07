extends AnimatedSprite


class_name BladeWave

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func startWave( pos, rot):
	var wave=$"."
	
	wave.global_position =pos
	wave.rotation_degrees=rot
	wave.frame=0;
	wave.play()
	visible=true
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BladeWave_animation_finished():
	visible=false
	var wave=$"."
	wave.stop()
