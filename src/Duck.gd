extends RigidBody2D
class_name Duck

var move_speed = 40
var patrol_path
var patrol_points
var patrol_index = 0
var velocity = Vector2.ZERO
var direction=1
var hitting=false
var ducklinCount =4;
var ducklinScene = preload("res://Ducklin.tscn")
var ducklins = []

func restetPath():
	if !patrol_path:
		return
	velocity = Vector2.ZERO
	direction=1
	patrol_index = 0
	position=patrol_points[patrol_index]
#	for i in ducklins.size():
#		ducklins[i].resetTarget()
    
func initDuck(new_patrol_path):
	patrol_path=new_patrol_path
	patrol_points=patrol_path.curve.get_baked_points()
	restetPath()
	spawnDucklins()
	visible=true
	
func is_class(name): 
	return "Duck"==name
	
func stop():	
	sleeping=true	
	visible=false
	for i in ducklins.size():
		ducklins[i].queue_free()
	ducklins=[]
		
func spawnDucklins():
	var prefDuck=self;
	var i=1;
	while i<=ducklinCount:
		var ducklin=ducklinScene.instance() as Ducklin
		ducklin.ducklinNr=i
		ducklin.follow_duck=prefDuck
		prefDuck=ducklin
		ducklin.visible=true
		ducklin.resetTarget()
		get_parent().call_deferred("add_child", ducklin)
		i=i+1
		ducklins.append(ducklin)
		
func _physics_process(diff):
	if !visible || !patrol_path  :
		      return
			
	var target = patrol_points[patrol_index]
	if hitting or position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + direction, 0, patrol_points.size())
		target = patrol_points[patrol_index]
		#target = patrol_path.GlobalPosition - GlobalPosition
	velocity = (target - position).normalized() * move_speed
	linear_velocity = velocity
	rotation= velocity.angle();
	
func _integrate_forces( statePhysics: Physics2DDirectBodyState):
	var collidingBodies=get_colliding_bodies()
	if collidingBodies.size()>0:
		if !hitting:
			direction=-direction;
			hitting=true
	else:
		hitting=false	
