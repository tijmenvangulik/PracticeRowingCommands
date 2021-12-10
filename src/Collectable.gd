extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var collected=false
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

		
func _on_Tween_tween_all_completed():
	visible=false

func reset():
	visible=true
	monitoring=true
	var sprite=$Sprite
	sprite.scale= Vector2(1,1)
	sprite.modulate=Color(1, 1, 1, 1)
	collected=false
	
	
func hide():
	visible=false
	monitoring=false


func _on_Collectable_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if !collected && area.name=="CollectableArea" :
		monitoring=false
		collected=true
		var scaleUp=4
		$"..".collect(1)
		$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.interpolate_property($Sprite, "scale", Vector2(0,0), Vector2(scaleUp,scaleUp), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		$Sound.stream.set_loop(false)
		$Sound.play()

