extends RigidBody2D

class_name Boat

export (NodePath) onready var rulesetManager = get_node(rulesetManager) as RuleSets

var velocity = Vector2.ZERO

var toRotation=0
var currentTurnSpeedFactor = 0.0
var currentSpeedFactor = 0.0

var max_speed = 60.0

var max_turn= 0.6

var lowTurnSpeed=1.0
var forceMultiplier=1.0
var sideWays=false;
var lightPaddleFactor=0.5
var lightPaddleDestTurnFactor=0.5
var lightPaddleOn=false

var bestExtraRotation=2

var bestState : int= Constants.BestState.Normal
var lowNoRowingSpeed=lightPaddleFactor*max_speed

var speedDirectErrorLevel=10
var newRotation_degrees=-1.0;
var newPosition_x=-1.0
var newPosition_y=-1.0
var onePush=false;
var crashState=false;

var state:int = Constants.RowState.LaatLopen



var lastCommand=-1
var newCommand=-1
var stateOars = Constants.StateOars.Roeien

var forwardsPositon=150
var backwardsPosition=-200
var currentPositionX=0;
var moveStep=1000

func _ready():
	setForwardsPosition(0)
	GameEvents.connect("zoomChangedSignal",self,"_zoomChangedSignal")
	GameEvents.connect("doCommandSignal",self,"_doCommandSignal")
	
func _process(delta):
	setForwardsPosition(delta)

var lastForwardsCommand=-1

func _zoomChangedSignal():
	setForwardsPosition(0)

func canPushSB():
	var ray=$RayCastSB
	ray.force_raycast_update()
	var result=ray.is_colliding()
	return result
	
func canPushBB():
	var ray=$RayCastSB
	ray.enabled=true
	ray.force_raycast_update()
	var result=ray.is_colliding()
	ray.enabled=false
	return result
	
func setForwardsPosition(delta):
	if delta!=0 && lastForwardsCommand!=lastCommand:
		if lastCommand==Constants.Command.StrijkenBeidenBoorden || lastCommand==Constants.Command.HalenBeideBoorden:
			if lastCommand==Constants.Command.StrijkenBeidenBoorden: GameState.isForwards=false
			else: GameState.isForwards=true			
			lastForwardsCommand=lastCommand;
			GameEvents.forwardBackwardsChanged()

	var positionX=forwardsPositon;	
	if !GameState.isForwards: positionX=backwardsPosition	
	
	
	if (currentPositionX!=positionX || delta==0):
		if delta==0 : currentPositionX=positionX
		else:
			if currentPositionX>positionX: currentPositionX=currentPositionX-(moveStep*delta)
			else: currentPositionX=currentPositionX+(moveStep*delta)
		if currentPositionX>forwardsPositon: currentPositionX=forwardsPositon
		if currentPositionX<backwardsPosition: currentPositionX=backwardsPosition
		var zoomDif=$"Camera2D2".zoom.x-0.5;
		$"Camera2D2".position= Vector2(currentPositionX*zoomDif,0)
		
		
func startTimer(time):
	var t = Timer.new()
	t.set_wait_time(time)
	t.set_one_shot(true)
	add_child(t)
	t.start()
	return t
	
func removeTimer(t):
	remove_child(t)
	t.queue_free()

func resetCrashed():
	crashState=false
	
func showError(message:String):
	
		var label=$"../CanvasLayer/errorLabel"
		label.text=tr(message)
		#remove the error message after 2 secons
		var t=startTimer(2)
		yield(t, "timeout")
		removeTimer(t)
		
		label.text=""

	
#http://kidscancode.org/godot_recipes/basics/understanding_delta/
# speed (velocity) is pixels per second
func _integrate_forces( statePhysics: Physics2DDirectBodyState):
	if newPosition_x!=-1.0:
		var start_pos=Vector2(newPosition_x,newPosition_y)
		var start_angle=deg2rad( newRotation_degrees)*1.0
		
		statePhysics.transform = Transform2D(start_angle, start_pos)
		statePhysics.linear_velocity = Vector2()
		newRotation_degrees=-1.0;
		newPosition_x=-1.0
		newPosition_y=1.0
	# calc speed
	var forceCorrection=1.0
	if (lightPaddleOn): forceCorrection=lightPaddleFactor
	
	var destinationSpeed=currentSpeedFactor*max_speed*forceCorrection;
	
	#calc rot
	var destinationTurnSpeed=currentTurnSpeedFactor*max_turn;
	
	var noturnLowSleed=state==Constants.RowState.VastroeienSB || state==Constants.RowState.VastroeienBB;
		
	if lightPaddleOn:
		destinationTurnSpeed=destinationTurnSpeed*lightPaddleDestTurnFactor
			
	# rotation += easeTurnSpeed * delta
	var sideWaysOffset=0
	if sideWays:
		if currentSpeedFactor<0 :
			sideWaysOffset=deg2rad(90);
		else: sideWaysOffset=deg2rad(-270)
	
	
	#apply easing	
	# var easeSpeed=doEase(currentSpeed,max_speed,-1.2);
	
	# velocity = Vector2(easeSpeed*delta, 0).rotated(rotation+sideWaysOffset)

	var currentSpeed=linear_velocity.length()
	var angle=linear_velocity.angle()
	var destinationSpeedAbs=abs(destinationSpeed)
	
	if destinationSpeedAbs>0 && currentSpeed<destinationSpeedAbs:
		applied_force= Vector2(destinationSpeed,0).rotated(rotation+sideWaysOffset)
	else: applied_force= Vector2(0,0)
	
	var destinationTurnSpeedAbs=abs(destinationTurnSpeed);
	# apply turn forces
	if destinationTurnSpeedAbs>0 && destinationSpeed!=0.0:
		if (sideWays):
			var extraTurnForce= Vector2(destinationTurnSpeed*0.5,0).rotated(rotation+sideWaysOffset)
			apply_impulse(Vector2(80,0).rotated(rotation),extraTurnForce)
		else:
			#apply_torque_impulse(destinationTurnSpeed*30);
			var extraTurnForce= Vector2(abs(destinationTurnSpeed)*0.5,0).rotated(rotation) #deg2rad(-45*sign(destinationTurnSpeed))
			apply_impulse(Vector2(0,-50*sign(destinationTurnSpeed)).rotated(rotation),extraTurnForce)
	#var collision = move_and_collide(velocity)
	
	# apply the breaking force
	
	if (destinationSpeed==0.0 and currentSpeed>0.5 ):
		var extraTurnForce= Vector2(currentSpeed*0.02*forceMultiplier,0).rotated(angle+PI)
		apply_impulse(Vector2(0,25*sign(destinationTurnSpeed)).rotated(rotation),extraTurnForce)
	
	if  destinationSpeed!=0.0 and currentSpeed>1:
		if bestState==Constants.BestState.StuurboordBest :
			apply_torque_impulse(-bestExtraRotation);
		else: if bestState==Constants.BestState.BakboordBest:
			apply_torque_impulse(bestExtraRotation);
	#check on colliding
	var collidingBodies=get_colliding_bodies()
	
	if collidingBodies.size()>0:
		changeState(Constants.RowState.LaatLopen,0)
		showError("Boem")
		crashState=true;
		 
	if onePush:
		currentSpeedFactor=0.0
		onePush=false;
		
	# Simulate the keel and reduce the side way forces
	if !sideWays && !crashState:
		#remove the rotation
		var force=linear_velocity.rotated(-rotation)
		if force.y>0.01 or force.y<-0.01:
			force.y=force.y*0.01;
			#rotate back
			linear_velocity=force.rotated(rotation)
		
				
static func doEase(currentValue,maxValue,easing):
	#https://godotengine.org/qa/59172/how-do-i-properly-use-the-ease-function
	if maxValue==0: return 0
	maxValue=abs(maxValue)
	var easeValue=ease((abs(currentValue)*1.0)/maxValue,easing)*maxValue
	if (currentValue<0): easeValue=easeValue*-1
	return 	easeValue
		
func setSpeedAndDirection(speedFactor:float,turnFactor:float,newForceMultiplier:float,newSideWays:bool):
	currentTurnSpeedFactor=turnFactor
	currentSpeedFactor=speedFactor
	forceMultiplier=newForceMultiplier
	sideWays=newSideWays;
	
	
func boatInRest():
	return state==Constants.RowState.LaatLopen ||	state==Constants.RowState.Bedankt 	 || isLowSpeed()

func isLowSpeed():
	return abs(linear_velocity.length())<speedDirectErrorLevel
	
func calcSpeed():
	var result=linear_velocity.length()
	var angle=abs(rad2deg( linear_velocity.angle()-rotation))
	if angle>170 && angle<190: result=result*-1
	return result
	
func getRules():
	return rulesetManager.getRuleset()
	
func doCommand(command:int):
	newCommand=command	
	match command:
		Constants.Command.HalenBeideBoorden:
			changeState(Constants.RowState.HalenBeideBoorden,1)
		Constants.Command.LaatLopen:
			changeState(Constants.RowState.LaatLopen,0)
		Constants.Command.Bedankt:
			changeState(Constants.RowState.Bedankt,0)
		Constants.Command.HalenSB:
			changeState(Constants.RowState.HalenSB,1)
		Constants.Command.StrijkenSB:
			changeState(Constants.RowState.StrijkenSB,-1)
		Constants.Command.VastroeienSB:
			changeState(Constants.RowState.VastroeienSB,0)
		Constants.Command.StrijkenBeidenBoorden:
			changeState(Constants.RowState.StrijkenBeidenBoorden,-1)
		Constants.Command.VastroeienBeideBoorden:
			changeState(Constants.RowState.VastroeienBeideBoorden,0)
		Constants.Command.HalenBB:
			changeState(Constants.RowState.HalenBB,1)
		Constants.Command.StrijkenBB:
			changeState(Constants.RowState.StrijkenBB,-1)
		Constants.Command.VastroeienBB:
			changeState(Constants.RowState.VastroeienBB,0)
		Constants.Command.PeddelendStrijkenBB:
			changeState(Constants.RowState.PeddelendStrijkenBB,0)
		Constants.Command.PeddelendStrijkenSB:
			changeState(Constants.RowState.PeddelendStrijkenSB,0)
		Constants.Command.UitzettenBB:
			changeState(Constants.RowState.UitzettenBB,0)
		Constants.Command.UitzettenSB:
			changeState(Constants.RowState.UitzettenSB,0)
		Constants.Command.RondmakenBB:
			changeState(Constants.RowState.RondmakenBB,-1)
		Constants.Command.RondmakenSB:
			changeState(Constants.RowState.RondmakenSB,-1)
		Constants.Command.Slippen:
			oarsCommand(Constants.OarsCommand2.Slippen)
		Constants.Command.Uitbrengen:
			oarsCommand(Constants.OarsCommand2.Uitbrengen)
		Constants.Command.SlippenSB:
			oarsCommand(Constants.OarsCommand2.SlippenSB)
		Constants.Command.UitbrengenSB:
			oarsCommand(Constants.OarsCommand2.UitbrengenSB)
		Constants.Command.SlippenBB:
			oarsCommand(Constants.OarsCommand2.SlippenBB)
		Constants.Command.UitbrengenBB:
			oarsCommand(Constants.OarsCommand2.UitbrengenBB)
		Constants.Command.LightPaddle:
			setLightPaddle(true)
		Constants.Command.LightPaddleBedankt:
			setLightPaddle(false)
		Constants.Command.RiemenHoogSB:
			oarsCommand(Constants.OarsCommand2.RiemenHoogSB)
		Constants.Command.RiemenHoogBB:
			oarsCommand(Constants.OarsCommand2.RiemenHoogBB)
		Constants.Command.StuurboordBest:
			setBest(Constants.BestState.StuurboordBest)
		Constants.Command.BakboortBest:
			setBest(Constants.BestState.BakboordBest)
		Constants.Command.BestBedankt:
			setBest(Constants.BestState.Normal)
		Constants.Command.SlagklaarAf:
			changeState(Constants.RowState.Roeien,1)
	lastCommand=command

	
func setLightPaddle(newLightPaddle:bool):
	var rules=getRules()
	var newValue=rules.determineLightPaddleState(self,newLightPaddle)
	if rules.error!="": showError(rules.error)
	else: lightPaddleOn=newValue


	
func setBest(newBestState :int):
	var rules=getRules()
	var newState=rules.determineBestState(self,newBestState)
	if rules.error!="": showError(rules.error)
	else: bestState= newState
	
func changeState(newState:int,direction:int):
	var oldState=state
	#first check if the new state is allowed	
	var rules=getRules()
	state=rules.determinenewState(self,newState,direction); 
	if rules.error!="": showError(rules.error)
	
	if oldState!=state: 
		crashState=false;
	#if the state change was successfull reset the oars state
	if  oldState!=state && (stateOars==Constants.StateOars.RiemenHoogBB || stateOars==Constants.StateOars.RiemenHoogSB ):
	  stateOars=Constants.StateOars.Roeien
 
	# going forward goes faster than backwards
	# change factor of Max speed, max rotat, speed inc,rotation inc
	# negative speed is backwards and negative turn speed is turn to the left
	match state:
		Constants.RowState.HalenBeideBoorden:
			setSpeedAndDirection(0.5,0,1,false)
		Constants.RowState.Roeien:
			setSpeedAndDirection(1,0,1,false)
		Constants.RowState.LaatLopen:
#			if abs(currentSpeed)<=lowNoRowingSpeed:
#				setSpeedAndDirection(0,0,0.001,false)
#			else: 
				setSpeedAndDirection(0,0,0.01,false)
		Constants.RowState.Bedankt:
#			if abs(currentSpeed)<=lowNoRowingSpeed:
#				setSpeedAndDirection(0,0,0.2,false)
#			else: 
				setSpeedAndDirection(0,0,1,false)
		Constants.RowState.HalenSB:
			setSpeedAndDirection(0.35,-0.5,1,false)
		Constants.RowState.HalenBB:
			setSpeedAndDirection(0.35,0.5,1,false)
		Constants.RowState.VastroeienBeideBoorden:
			setSpeedAndDirection(0,0,1.5,false)
		Constants.RowState.VastroeienSB:
			setSpeedAndDirection(0,0.6,0.4,false)
		Constants.RowState.VastroeienBB:
			setSpeedAndDirection(0,-0.6,0.4,false)
		Constants.RowState.StrijkenBeidenBoorden:
			setSpeedAndDirection(-0.4,0,0.5,false)
		Constants.RowState.StrijkenBB:
			setSpeedAndDirection(-0.3,-0.3,0.5,false)
		Constants.RowState.StrijkenSB:
			setSpeedAndDirection(-0.3,0.3,0.5,false)
		Constants.RowState.PeddelendStrijkenBB:
			setSpeedAndDirection(0.1,-0.1,1,true)
		Constants.RowState.PeddelendStrijkenSB:
			setSpeedAndDirection(-0.1,0.1,1,true)
		Constants.RowState.UitzettenBB:
			onePush=true
			state=Constants.RowState.LaatLopen
			setSpeedAndDirection(60,0,1,true)
		Constants.RowState.UitzettenSB:
			onePush=true
			state=Constants.RowState.LaatLopen
			setSpeedAndDirection(-60,0,1,true)
		Constants.RowState.RondmakenBB:
			setSpeedAndDirection(0.01,-0.5,1,false)
		Constants.RowState.RondmakenSB:
			setSpeedAndDirection(0.01,0.5,1,false)

func determinenewStateOars(newStateOars):
	return 	newStateOars
		
func setStateOars(newStateOars : int):
	stateOars=determinenewStateOars(newStateOars)
	$"Sprite".visible=false
	$"CollisionPolygon2D".disabled=true
	$"SpriteSlippen".visible=false
	$"CollisionSlippen".disabled=true
	$"SpriteSlippenSB".visible=false
	$"CollisionSlippenSB".disabled=true
	$"SpriteSlippenBB".visible=false
	$"CollisionSlippenBB".disabled=true
	$"CollisionRiemenHoogBB".disabled=true
	$"CollisionRiemenHoogSB".disabled=true
	match stateOars:
		Constants.StateOars.Roeien:
			$"Sprite".visible=true
			$"CollisionPolygon2D".disabled=false
		Constants.StateOars.Slippen:
			$"SpriteSlippen".visible=true
			$"CollisionSlippen".disabled=false
		Constants.StateOars.SlippenSB:
			$"SpriteSlippenSB".visible=true
			$"CollisionSlippenSB".disabled=false
			
		Constants.StateOars.SlippenBB:
			$"SpriteSlippenBB".visible=true
			$"CollisionSlippenBB".disabled=false
		Constants.StateOars.RiemenHoogSB:
			$"Sprite".visible=true
			$"CollisionRiemenHoogSB".disabled=false
		Constants.StateOars.RiemenHoogBB:
			$"Sprite".visible=true
			$"CollisionRiemenHoogBB".disabled=false

func oarsCommand(command: int):
	var rules=getRules()
	var newOarsState=rules.determineOarsState(self,command)
	if rules.error!="": showError(rules.error)
	else: 
		if newOarsState!=stateOars: setStateOars(newOarsState)
	
	
func setNewBoatPosition(x:int,y:int,newRotation,newStateOars : int,newIsForwards):
	GameState.isForwards=newIsForwards
	setForwardsPosition(0)
	# reset the boat into a new position and place
	setStateOars(newStateOars)
	newRotation_degrees=newRotation
	newPosition_x=x
	newPosition_y=y
	lightPaddleOn=false
	bestState=Constants.BestState.Normal
	# reset speed or turn
	state=Constants.RowState.LaatLopen
	currentSpeedFactor=0
	currentTurnSpeedFactor=0
	linear_velocity=Vector2(0,0)
	angular_velocity=0.0
  
func _doCommandSignal(command:int):
	doCommand(command)
