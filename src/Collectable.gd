extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var triggerWhenBoatIsStopped=false
var collected=false
var isEntered=false
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var slowTween= [1,1.5]

func startSlowTween():
	$TweenSlow.interpolate_property($SpriteTransparent, "scale", Vector2(slowTween[0],slowTween[0]), Vector2(slowTween[1],slowTween[1]), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	$TweenSlow.start()

func _on_TweenSlow_tween_all_completed():
	slowTween.invert()
	startSlowTween()
	
func _on_Tween_tween_all_completed():
	visible=false

func reset():
	$Tween.stop_all()
	$TweenSlow.stop_all()
	visible=true
	monitoring=true
	var sprite=$Sprite
	sprite.scale= Vector2(1,1)
	sprite.modulate=Color(1, 1, 1, 1)
	$SpriteTransparent.modulate=Color(1, 1, 1, 0.5)
	collected=false
	isEntered=false
	startSlowTween()
	
func hide():
	visible=false
	monitoring=false
	isEntered=false
	$TweenSlow.stop_all()

func doCollect():
	monitoring=false
	collected=true
	$TweenSlow.stop_all()
	var scaleUp=4
	$"..".collect(1)
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property($Sprite, "scale", Vector2(0,0), Vector2(scaleUp,scaleUp), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$Sound.stream.set_loop(false)
	$Sound.play()

func _on_Collectable_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name=="CollectableArea":
		isEntered=true
		if !collected && !triggerWhenBoatIsStopped :
			doCollect()
			
func _on_Collectable_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.name=="CollectableArea":
		isEntered=false

func _process(delta):
	if triggerWhenBoatIsStopped:
		if self.visible && !collected && isEntered && triggerWhenBoatIsStopped && $"%Boat".isStopped() && $"%Boat".state==Constants.RowState.Bedankt :
			doCollect()
		




