extends AnimatedSprite


class_name BladeWave

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var waveCounter=0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func startWave( pos, rot,isEnd,delta):
	var wave=$"."
	
	wave.global_position =pos
	wave.rotation_degrees=rot
	
	if isEnd:
		wave.play()
	
	if !visible:
		visible=true
	
	# when it is the first delta is 0
	if !isEnd && delta==0:
		modulate.a=0
		waveCounter=0
	else:
		if visible:
			waveCounter=waveCounter+delta
		if visible && modulate.a!=1:
			modulate.a=modulate.a+ delta
			
			if modulate.a>1:
				modulate.a=1
	if isEnd:
		wave.frame=0
	else:
		var frame=(floor(waveCounter * 4) as int)  % 2
		wave.frame=frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BladeWave_animation_finished():
	visible=false
	var wave=$"."
	wave.stop()
