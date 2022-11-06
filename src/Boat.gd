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
var lightPaddleFactor=0.6
var lightPaddleDestTurnFactor=0.5
var lightPaddleOn=false

var bestExtraRotation=1.5

var bestState : int= Constants.BestState.Normal
var lowNoRowingSpeed=lightPaddleFactor*max_speed

var speedDirectErrorLevel=15
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
	$"OarBB2".masterOar=$"OarBB1"
	$"OarSB2".masterOar=$"OarSB1"
	$"OarBB1".slaveOar=$"OarBB2"
	$"OarSB1".slaveOar=$"OarSB2"
	
	$"OarBB1".otherSideOar=$"OarSB1"
	$"OarSB1".otherSideOar=$"OarBB1"
	$"OarBB2".otherSideOar=$"OarSB2"
	$"OarSB2".otherSideOar=$"OarBB2"
	
	
	
func _process(delta):
	setForwardsPosition(delta)
	updateOarRotation()
	
func updateOarRotation():
	$"OarBB1Collision".rotation_degrees=$"OarBB1".rotation_degrees-90-180
	$"OarBB2Collision".rotation_degrees=$"OarBB2".rotation_degrees-90-180

	$"OarSB1Collision".rotation_degrees=$"OarSB1".rotation_degrees-90-180
	$"OarSB2Collision".rotation_degrees=$"OarSB2".rotation_degrees-90-180
	
	
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
		if lastCommand==Constants.Command.StrijkenBeidenBoorden || lastCommand==Constants.Command.HalenBeideBoorden || lastCommand==Constants.Command.SlagklaarAf:
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
	var oarsInwater=$"OarBB1".inWater || $"OarSB1".inWater
	
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
	
	if (oarsInwater || sideWays) && destinationSpeedAbs>0 && currentSpeed<destinationSpeedAbs:
		applied_force= Vector2(destinationSpeed,0).rotated(rotation+sideWaysOffset)
	else: applied_force= Vector2(0,0)
	
	var destinationTurnSpeedAbs=abs(destinationTurnSpeed);
	# apply turn forces
	if  destinationTurnSpeedAbs>0 && destinationSpeed!=0.0:
		if (sideWays):
			var extraTurnForce= Vector2(destinationTurnSpeed*0.5,0).rotated(rotation+sideWaysOffset)
			apply_impulse(Vector2(80,0).rotated(rotation),extraTurnForce)
		elif oarsInwater:
			#apply_torque_impulse(destinationTurnSpeed*30);
			var extraTurnForce= Vector2(abs(destinationTurnSpeed)*0.5,0).rotated(rotation) #deg2rad(-45*sign(destinationTurnSpeed))
			apply_impulse(Vector2(0,-50*sign(destinationTurnSpeed)).rotated(rotation),extraTurnForce)
	#var collision = move_and_collide(velocity)
	
	# apply the breaking force
	
	if oarsInwater and destinationSpeed==0.0 and currentSpeed>0.2 :
		var extraTurnForce= Vector2(currentSpeed*0.02*forceMultiplier,0).rotated(angle+PI)
		apply_impulse(Vector2(0,25*sign(destinationTurnSpeed)).rotated(rotation),extraTurnForce)
	
		
	if  oarsInwater and destinationSpeed!=0.0 and currentSpeed>1:
		if bestState==Constants.BestState.StuurboordBest :
			apply_torque_impulse(-bestExtraRotation);
		else: if bestState==Constants.BestState.BakboordBest:
			apply_torque_impulse(bestExtraRotation);
			
	#check on colliding
	var collidingBodies=get_colliding_bodies()
	
	var crashStateChanged= !crashState
	if crashStateChanged && collidingBodies.size()>0 :
		var body=collidingBodies[0]
		var isDuck= body.is_class("Duck") 
		
		if (!isDuck || !isLowSpeed() || isTurning()):
			
			crashState=true;
			changeState(Constants.Command.LaatLopen,Constants.RowState.LaatLopen,0,true)
			var sound=$"CrashSound"
			if isDuck:
				showError("Kwak")
				sound=$"CrashSoundDuck"
			else:
				showError("Boem")
			if !sound.playing && crashStateChanged:
				sound.play()
			$"OarBB1".freeze()
			$"OarSB1".freeze()
		 
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

func isTurning():
	return abs(get_angular_velocity())>0.05
	
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
			setStateOars(Constants.StateOars.Roeien,false);
			changeState(command,Constants.RowState.HalenBeideBoorden,1)
		Constants.Command.LaatLopen:
			changeState(command,Constants.RowState.LaatLopen,0)
		Constants.Command.Bedankt:
			changeState(command,Constants.RowState.Bedankt,0)
		Constants.Command.HalenSB:
			changeState(command,Constants.RowState.HalenSB,1)
		Constants.Command.StrijkenSB:
			changeState(command,Constants.RowState.StrijkenSB,-1)
		Constants.Command.VastroeienSB:
			changeState(command,Constants.RowState.VastroeienSB,0)
		Constants.Command.StrijkenBeidenBoorden:
			setStateOars(Constants.StateOars.Roeien,false);
			changeState(command,Constants.RowState.StrijkenBeidenBoorden,-1)
		Constants.Command.VastroeienBeideBoorden:
			setStateOars(Constants.StateOars.Roeien,false);
			changeState(command,Constants.RowState.VastroeienBeideBoorden,0)
		Constants.Command.HalenBB:
			changeState(command,Constants.RowState.HalenBB,1)
		Constants.Command.StrijkenBB:
			changeState(command,Constants.RowState.StrijkenBB,-1)
		Constants.Command.VastroeienBB:
			changeState(command,Constants.RowState.VastroeienBB,0)
		Constants.Command.PeddelendStrijkenBB:
			changeState(command,Constants.RowState.PeddelendStrijkenBB,0)
		Constants.Command.PeddelendStrijkenSB:
			changeState(command,Constants.RowState.PeddelendStrijkenSB,0)
		Constants.Command.UitzettenBB:
			changeState(command,Constants.RowState.UitzettenBB,0)
		Constants.Command.UitzettenSB:
			changeState(command,Constants.RowState.UitzettenSB,0)
		Constants.Command.RondmakenBB:
			changeState(command,Constants.RowState.RondmakenBB,-1)
		Constants.Command.RondmakenSB:
			changeState(command,Constants.RowState.RondmakenSB,-1)
		Constants.Command.Slippen:
			oarsCommand(command,Constants.OarsCommand2.Slippen)
		Constants.Command.Uitbrengen:
			oarsCommand(command,Constants.OarsCommand2.Uitbrengen)
		Constants.Command.SlippenSB:
			oarsCommand(command,Constants.OarsCommand2.SlippenSB)
		Constants.Command.UitbrengenSB:
			oarsCommand(command,Constants.OarsCommand2.UitbrengenSB)
		Constants.Command.SlippenBB:
			oarsCommand(command,Constants.OarsCommand2.SlippenBB)
		Constants.Command.UitbrengenBB:
			oarsCommand(command,Constants.OarsCommand2.UitbrengenBB)
		Constants.Command.LightPaddle:
			setLightPaddle(command,true)
		Constants.Command.LightPaddleBedankt:
			setLightPaddle(command,false)
		Constants.Command.RiemenHoogSB:
			oarsCommand(command,Constants.OarsCommand2.RiemenHoogSB)
		Constants.Command.RiemenHoogBB:
			oarsCommand(command,Constants.OarsCommand2.RiemenHoogBB)
		Constants.Command.StuurboordBest:
			setBest(command,Constants.BestState.StuurboordBest)
		Constants.Command.BakboortBest:
			setBest(command,Constants.BestState.BakboordBest)
		Constants.Command.BestBedankt:
			setBest(command,Constants.BestState.Normal)
		Constants.Command.SlagklaarAf:
			setStateOars(Constants.StateOars.Roeien,false);
			changeState(command,Constants.RowState.Roeien,1)
		Constants.Command.PakMaarWeerOp:
			if calcSpeed()<0:
				changeState(command,Constants.RowState.StrijkenBeidenBoorden,-1)
			else:
				changeState(command,Constants.RowState.Roeien,1)
	lastCommand=command

	
func setLightPaddle(command :int,newLightPaddle:bool):
	var rules=getRules()
	var newValue=rules.determineLightPaddleState(self,command,newLightPaddle)
	if rules.error!="": showError(rules.error)
	else: lightPaddleOn=newValue


	
func setBest(command :int,newBestState :int):
	var rules=getRules()
	var newState=rules.determineBestState(self,command,newBestState)
	if rules.error!="": showError(rules.error)
	else: bestState= newState
	
func changeState(command:int,newState:int,direction:int,direct=false):
	var oldState=state
	#first check if the new state is allowed	
	var rules=getRules()
	state=rules.determinenewState(self,command,newState,direction); 
	if rules.error!="": showError(rules.error)
	
	if oldState!=state: 
		crashState=false;
	#if the state change was successfull reset the oars state
	if  oldState!=state && (stateOars==Constants.StateOars.RiemenHoogBB || stateOars==Constants.StateOars.RiemenHoogSB ):
	  stateOars=Constants.StateOars.Roeien
	
	var oarBB=$"OarBB1"
	var oarSB=$"OarSB1"
	
	var slippenBB=stateOars==Constants.StateOars.SlippenBB || stateOars==Constants.StateOars.Slippen;
	var slippenSB=stateOars==Constants.StateOars.SlippenSB || stateOars==Constants.StateOars.Slippen;
	
	# going forward goes faster than backwards
	# change factor of Max speed, max rotat, speed inc,rotation inc
	# negative speed is backwards and negative turn speed is turn to the left
	match state:
		Constants.RowState.HalenBeideBoorden:
			setSpeedAndDirection(0.4,0,1,false)
			oarBB.setNewScheme(true,oarBB.rotation_inHalen,oarBB.rotation_out,direct,true)
			oarSB.setNewScheme(true,oarBB.rotation_inHalen,oarBB.rotation_out,direct,true)
		Constants.RowState.Roeien:
			setSpeedAndDirection(0.6,0,1,false)
			oarBB.setNewScheme(true,oarBB.rotation_in,oarBB.rotation_out,direct,true)
			oarSB.setNewScheme(true,oarBB.rotation_in,oarBB.rotation_out,direct,true)
		Constants.RowState.LaatLopen:
#			if abs(currentSpeed)<=lowNoRowingSpeed:
#				setSpeedAndDirection(0,0,0.001,false)
#			else: 
			bestState=Constants.BestState.Normal;
			setSpeedAndDirection(0,0,0.01,false)
			if !crashState:
				if !slippenBB:
					oarBB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)
				if !slippenSB:
					oarSB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)

		Constants.RowState.Bedankt:
#			if abs(currentSpeed)<=lowNoRowingSpeed:
#				setSpeedAndDirection(0,0,0.2,false)
#			else: 
			setSpeedAndDirection(0,0,1,false)
			bestState=Constants.BestState.Normal;
			
			if slippenBB:
				oarBB.setNewScheme(false,oarBB.rotation_slippen,oarBB.rotation_slippen,direct)
			else:
				oarBB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)

			if slippenSB:
				oarSB.setNewScheme(false,oarBB.rotation_slippen,oarBB.rotation_slippen,direct)
			else:
				oarSB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)

		Constants.RowState.HalenSB:
			setSpeedAndDirection(0.35,-0.3,1,false)
			oarSB.setNewScheme(true,oarBB.rotation_inHalen,oarBB.rotation_out,direct)
		Constants.RowState.HalenBB:
			setSpeedAndDirection(0.35,0.3,1,false)
			oarBB.setNewScheme(true,oarBB.rotation_inHalen,oarBB.rotation_out,direct)
		Constants.RowState.VastroeienBeideBoorden:
			setSpeedAndDirection(0,0,0.4,false)
			if !slippenBB:
				oarBB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct,true)
			if !slippenSB:
				oarSB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct,true)
		Constants.RowState.VastroeienSB:
			setSpeedAndDirection(0,0.5,0.3,false)
			if !slippenSB:
				oarSB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct)
		Constants.RowState.VastroeienBB:
			setSpeedAndDirection(0,-0.5,0.3,false)
			if !slippenBB:
				oarBB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct)
			if !slippenSB:
				oarSB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)
		Constants.RowState.StrijkenBeidenBoorden:
			setSpeedAndDirection(-0.4,0,0.5,false)
			oarBB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct,true)
			oarSB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct,true)

		Constants.RowState.StrijkenBB:
			setSpeedAndDirection(-0.3,-0.3,0.5,false)
			oarBB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
		Constants.RowState.StrijkenSB:
			setSpeedAndDirection(-0.3,0.3,0.5,false)
			oarSB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
		Constants.RowState.PeddelendStrijkenBB:
			setSpeedAndDirection(0.1,-0.1,1,true)
			oarBB.setNewScheme(true,oarBB.rotation_slippen,oarBB.rotation_slippen_out,direct)
		Constants.RowState.PeddelendStrijkenSB:
			setSpeedAndDirection(-0.1,0.1,1,true)
			oarSB.setNewScheme(true,oarBB.rotation_slippen,oarBB.rotation_slippen_out,direct)
		Constants.RowState.UitzettenBB:
			onePush=true
			state=Constants.RowState.LaatLopen
			setSpeedAndDirection(12,0,1,true)
		Constants.RowState.UitzettenSB:
			onePush=true
			state=Constants.RowState.LaatLopen
			setSpeedAndDirection(-12,0,1,true)
		Constants.RowState.RondmakenBB:
			setSpeedAndDirection(0.01,-0.5,1,false)
			oarBB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
			oarSB.setNewScheme(false,oarBB.rotation_out,oarBB.rotation_inHalen,direct)

		Constants.RowState.RondmakenSB:
			setSpeedAndDirection(0.01,0.5,1,false)
			oarBB.setNewScheme(false,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
			oarSB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct)

func determinenewStateOars(newStateOars):
	return 	newStateOars
		
func setStateOars(newStateOars : int,direct : bool):
	var oldStateOars=stateOars
	stateOars=determinenewStateOars(newStateOars)
	var oarBB=$"OarBB1"
	var oarSB=$"OarSB1"
	if direct:
		oarBB.setNewScheme(false,oarSB.rotation_rest,oarBB.rotation_rest,direct)	
		oarSB.setNewScheme(false,oarSB.rotation_rest,oarBB.rotation_rest,direct)	
	
	match stateOars:
		Constants.StateOars.Roeien:
			oarBB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)
			oarSB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)	
			RimenHoogSetDisabledBB(false)
			RimenHoogSetDisabledSB(false)
#			$"Sprite".visible=true
#			$"CollisionPolygon2D".disabled=false
		Constants.StateOars.Slippen:
			oarBB.setNewScheme(false,oarBB.rotation_slippen,oarBB.rotation_slippen,direct)
			oarSB.setNewScheme(false,oarBB.rotation_slippen,oarBB.rotation_slippen,direct)
			RimenHoogSetDisabledBB(false)
			RimenHoogSetDisabledSB(false)
		Constants.StateOars.SlippenSB:
			RimenHoogSetDisabledSB(false)
			oarSB.setNewScheme(false,oarBB.rotation_slippen,oarBB.rotation_slippen,direct)
			if oldStateOars==Constants.StateOars.Slippen:
				oarBB.setNewScheme(false,oarSB.rotation_rest,oarBB.rotation_rest,direct)	
		Constants.StateOars.SlippenBB:
			oarBB.setNewScheme(false,oarBB.rotation_slippen,oarBB.rotation_slippen,direct)
			if oldStateOars==Constants.StateOars.Slippen:
				oarSB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)
			RimenHoogSetDisabledBB(false)
		Constants.StateOars.RiemenHoogSB:
			oarSB.setNewScheme(false,oarBB.rotation_center,oarBB.rotation_center,direct)
			RimenHoogSetDisabledSB(true)
#			$"CollisionRiemenHoogSB".disabled=false
		Constants.StateOars.RiemenHoogBB:
			oarBB.setNewScheme(false,oarBB.rotation_center,oarBB.rotation_center,direct)
			RimenHoogSetDisabledBB(true)
#			$"CollisionRiemenHoogBB".disabled=false
	if direct:
		updateOarRotation()
		
func RimenHoogSetDisabledSB(value):
	$"OarSB1Collision".disabled=value
	$"OarSB2Collision".disabled=value
	
func RimenHoogSetDisabledBB(value):
	$"OarBB1Collision".disabled=value
	$"OarBB2Collision".disabled=value
	
func oarsCommand(command: int,oarsCommand: int):
	var rules=getRules()
	var newOarsState=rules.determineOarsState(self,command,oarsCommand)
	if rules.error!="": showError(rules.error)
	else: 
		if newOarsState!=stateOars: setStateOars(newOarsState,false)
	
	
func setNewBoatPosition(x:int,y:int,newRotation,newStateOars : int,newIsForwards):
	GameState.isForwards=newIsForwards
	setForwardsPosition(0)
	setStateOars(newStateOars,true)
	
	# reset the boat into a new position and place
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
