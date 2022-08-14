extends RigidBody2D

class_name Ducklin

#export (NodePath) var follow_duck 
#export (NodePath) onready var follow_duck = get_node(follow_duck) as RigidBody2D
var follow_duck 

var velocity = Vector2.ZERO
var move_speed = 40
var behindDistance= 60
var ducklinNr=0
var rotationStep=0.2
# Called when the node enters the scene tree for the first time.
func _ready():
	if visible:
		resetTarget()
		
func resetTarget():
		var target=getTarget()
		if target:
			position=target

func is_class(name): 
	return "Duck"==name
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass=
func _physics_process(diff):
	if visible:
		var target=getTarget() as Vector2
		if target:
			if (target - position).length()< 40:
				velocity=Vector2(0,0)
				linear_velocity=Vector2(0,0)
			else:
				velocity = (target - position).normalized() * move_speed
				linear_velocity = velocity
				
				
				rotation=velocity.angle()
				#var rotDif=rotation-velocity.angle();
				#if abs(rotDif)<=rotationStep:
				#	rotation= velocity.angle();
				#elif rotDif>0: 
				#	rotate(rotationStep)
				#else: 
				#	rotate(-rotationStep)
			
		
func getTarget():
	if follow_duck:
		var pos=follow_duck.position
		var rot=follow_duck.rotation+PI
		var behind=Vector2(behindDistance,0).rotated(rot)
		return pos+behind
	else:
		return null
