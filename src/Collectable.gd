extends Area2D

class_name Collectable

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var triggerWhenBoatIsStopped=false
var collected=false
var isEntered=false
var stopWarningGiven=false
var warningStartDelay =0
# Called when the node enters the scene tree for the first time.


export var spriteStyle : int = 0

export var practiceStartPosNr : int = -1

func get_optional_node(obj):
	if obj==null: return null
	else: return get_node(obj)

export (NodePath) onready var requiredCollectable = get_optional_node(requiredCollectable) as Collectable

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var slowTween= [0.8,1.1]

func _ready():
	setIconStyle(spriteStyle)

var starSprite=load("res://assets/star.png")
var startPractice=load("res://assets/starPractice.png")
var starPracticeCollected=load("res://assets/starPracticeCollected.png")

func setIconStyle(newStyle):
	spriteStyle=newStyle
	if spriteStyle==Constants.CollectableSpriteStyle.Game:
		$Sprite.texture= starSprite
	elif spriteStyle==Constants.CollectableSpriteStyle.Practice:
		$Sprite.texture= startPractice
	elif spriteStyle==Constants.CollectableSpriteStyle.PracticeCollected:
		$Sprite.texture= starPracticeCollected

func startSlowTween():
	$TweenSlow.interpolate_property(self, "scale", Vector2(slowTween[0],slowTween[0]), Vector2(slowTween[1],slowTween[1]), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	$TweenSlow.start()
	

func _on_TweenSlow_tween_all_completed():
	slowTween.invert()
	startSlowTween()
	
func _on_Tween_tween_all_completed():
	visible=false

func reset():
	#wait a bit to fix problem that the position is reset earlier than the collection item is showing
	var t=Utilities.startTimer(0.1)
	yield(t, "timeout")
	Utilities.removeTimer(t)
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
	warningStartDelay=0
	
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
		if  !collected && !triggerWhenBoatIsStopped && (requiredCollectable==null || requiredCollectable.collected ) :
			doCollect()
			
func _on_Collectable_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.name=="CollectableArea":
		isEntered=false

func _process(delta):
	if visible && triggerWhenBoatIsStopped:
		if !collected && isEntered && triggerWhenBoatIsStopped && $"%Boat".isStopped():
			if $"%Boat".state==Constants.RowState.Bedankt:
				warningStartDelay=0
				doCollect()
			elif warningStartDelay==0:
				warningStartDelay=Time.get_ticks_msec()
		# when forgotten to say drop off then give a message
		if warningStartDelay>0 && (Time.get_ticks_msec()-warningStartDelay)>2000:
			warningStartDelay=0
			var text=tr("DoNotForgetEasyOff")
			text=Utilities.replaceCommandsInText(text,false)
			$"%Boat".showError(text)
		




