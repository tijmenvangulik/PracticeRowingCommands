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
var lightPaddleFactor=0.7
var lightPaddleDestTurnFactor=0.5
var lightPaddleOn=false

var bestExtraRotation=1.5

var bestState : int= Constants.BestState.Normal
var lowNoRowingSpeed=lightPaddleFactor*max_speed

var speedDirectErrorLevel=15
var speedDirectErrorLevelBridge=10

var speedCommandSwitchErrorLevel=20
var speedIsStopped=4
var newRotation_degrees=-1.0;
var newPosition_x=-1.0
var newPosition_y=-1.0
var onePush=false;
var crashState=false;

var state:int = Constants.RowState.LaatLopen
var oneStroke = false;


var org_linear_damp=0

var lastCommand=-1
var newCommand=-1
var stateOars = Constants.StateOars.Roeien

var forwardsPositon=150
var backwardsPosition=-200
var currentPositionX=0;
var moveStep=1000
var isDuckCrash = false

func _ready():
	
	setForwardsPosition(0)
	GameEvents.connect("zoomChangedSignal",self,"_zoomChangedSignal")
	GameEvents.connect("doCommandSignal",self,"_doCommandSignal")
	GameEvents.connect("isScullChangedSignal",self,"_isScullSignal")
	GameEvents.connect("introSignal",self,"_introSignal")

	$"OarBB2".masterOar=$"OarBB1"
	$"OarSB2".masterOar=$"OarSB1"
	$"OarBB1".slaveOar=$"OarBB2"
	$"OarSB1".slaveOar=$"OarSB2"
	
	$"OarBB1".otherSideOar=$"OarSB1"
	$"OarSB1".otherSideOar=$"OarBB1"
	$"OarBB2".otherSideOar=$"OarSB2"
	$"OarSB2".otherSideOar=$"OarBB2"
	org_linear_damp=linear_damp
	
	$"OarBB2".bladeWave=$"%BladeWaveBB2"
	$"OarSB2".bladeWave=$"%BladeWaveSB2"
	$"OarBB1".bladeWave=$"%BladeWaveBB1"
	$"OarSB1".bladeWave=$"%BladeWaveSB1"
	
	$"OarBB1".collision=$"OarBB1Collision"
	$"OarSB1".collision=$"OarSB1Collision"
	$"OarBB2".collision=$"OarBB2Collision"
	$"OarSB2".collision=$"OarSB2Collision"
	
	
func _isScullSignal(isScull):
	$"OarBB1".visible=isScull
	$"OarSB2".visible=isScull
	
func _physics_process(delta):
	setForwardsPosition(delta)
	updateOarCollision()
	
func updateOarCollision():
	$"OarBB1Collision".rotation_degrees=$"OarBB1".rotation_degrees-90-180
	$"OarBB2Collision".rotation_degrees=$"OarBB2".rotation_degrees-90-180
	
	$"OarSB1Collision".rotation_degrees=$"OarSB1".rotation_degrees-90-180
	$"OarSB2Collision".rotation_degrees=$"OarSB2".rotation_degrees-90-180
	
	$"OarBB1Collision".position.y=$"OarBB1".position.y
	$"OarBB2Collision".position.y=$"OarBB2".position.y
	$"OarSB1Collision".position.y=$"OarSB1".position.y
	$"OarSB2Collision".position.y=$"OarSB2".position.y
	
var lastForwardsCommand=-1

func _zoomChangedSignal():
	setForwardsPosition(0)

func canPushSB():
	var ray=$RayCastSB
	ray.force_raycast_update()
	var result=ray.is_colliding()
	return result
	
func canPushBB():
	var ray=$RayCastBB
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
		
		

func resetCrashed():
	crashState=false
	isDuckCrash=false

var _errorTimer=null

func showError(message:String,time=2):
		if _errorTimer!=null:
			Utilities.removeTimer(_errorTimer)
		
		var label=$"../CanvasLayer/errorLabel"
		label.text=tr(message)
		#remove the error message after 2 secons
		_errorTimer=Utilities.startTimer(time)
		yield(_errorTimer, "timeout")
		Utilities.removeTimer(_errorTimer)
		_errorTimer=null
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
	var oarsInwater=($"OarBB1".inWater) || ( $"OarSB1".inWater)
	var oarsInwaterRowing=($"OarBB1".isRowing() && $"OarBB1".inWater) || ($"OarSB1".isRowing() && $"OarSB1".inWater)
	var rowingAndBreakingTogether=!oarsInwaterRowing && oarsInwater;
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
	
	if (oarsInwaterRowing || sideWays) && destinationSpeedAbs>0 && currentSpeed<destinationSpeedAbs:
		applied_force= Vector2(destinationSpeed,0).rotated(rotation+sideWaysOffset)
	else: applied_force= Vector2(0,0)
	
	var destinationTurnSpeedAbs=abs(destinationTurnSpeed);
	# apply turn forces
	if  destinationTurnSpeedAbs>0 && destinationSpeed!=0.0:
		if (sideWays):
			var extraTurnForce= Vector2(destinationTurnSpeed*0.5,0).rotated(rotation+sideWaysOffset)
			apply_impulse(Vector2(80,0).rotated(rotation),extraTurnForce)
		elif oarsInwater:
			if rowingAndBreakingTogether:
				destinationTurnSpeed=destinationTurnSpeed*0.2
			#apply_torque_impulse(destinationTurnSpeed*30);
			var extraTurnForce= Vector2(abs(destinationTurnSpeed)*0.5,0).rotated(rotation) #deg2rad(-45*sign(destinationTurnSpeed))
			apply_impulse(Vector2(0,-50*sign(destinationTurnSpeed)).rotated(rotation),extraTurnForce)
	#var collision = move_and_collide(velocity)
	
	# apply the breaking force
	
	if oarsInwater and destinationSpeed==0.0 and currentSpeed>0.1 :
		# increase the turn factor when the speed is low
		# this is due to the keel which works less at low speed 
		# (It may be better to fix this in the future by changing the keel algo, but this fix is for now more safe )
		var turnFactor1=0.03
		if currentSpeed>10:
			turnFactor1=0.02
		if currentSpeed>17:
			turnFactor1=0.015
		if currentSpeed>15:
			turnFactor1=0.01
		if currentSpeed>17:
			turnFactor1=0.008
		if currentSpeed>20:
			turnFactor1=0.007
		#if oarsInwaterRowing:
		#	turnFactor1=0.0000
		var turnFactor=currentSpeed*turnFactor1*forceMultiplier ;
		
		var extraTurnForce= Vector2(turnFactor,0).rotated(angle+PI)
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
			changeState(Constants.Command.LaatLopen,Constants.RowState.LaatLopen,0,true)
			isDuckCrash=isDuck
			crashState=true;
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
			GameEvents.crash()
		 
	if onePush:
		currentSpeedFactor=0.0
		onePush=false;
	
	if sideWays:
		linear_damp=0.95
	else:
		 linear_damp=org_linear_damp
	# Simulate the keel and reduce the side way forces
	if !sideWays && !(crashState && !isDuckCrash) :
		#remove the rotation
		var force=linear_velocity.rotated(-rotation)
		if force.y>0.01 or force.y<-0.01:
			force.y=force.y*0.01;
			#rotate back
			linear_velocity=force.rotated(rotation)
		
	calcRippleEffect()

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
	
func getSpeedDirectErrorLevel():
	if 	$"%OptionStart".currentStartPos==Constants.StartItem.BridgePractice:
		return speedDirectErrorLevelBridge
	return speedDirectErrorLevel

func boatInRest():
	return state==Constants.RowState.LaatLopen ||	state==Constants.RowState.Bedankt 	 || isLowSpeed()

func isLowSpeed():
	return abs(linear_velocity.length())<getSpeedDirectErrorLevel()

func isLowSpeedCommandSwitch():
	return abs(linear_velocity.length())<speedCommandSwitchErrorLevel
func isStopped():
	return abs(linear_velocity.length())<speedIsStopped

func isTurning():
	return abs(get_angular_velocity())>0.05
	
func calcSpeed():
	var result=linear_velocity.length()
	var angle=abs(rad2deg( linear_velocity.angle()-rotation))
	if angle>170 && angle<190: result=result*-1
	return result

func movingBackwards():
	return calcSpeed()<0

func getRules():
	return rulesetManager.getRuleset()
	
func doCommand(command:int):
	var recorder=$"%Recorder"
	if recorder.isRecording:
		recorder.recordCommad(command)
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
		Constants.Command.IntrekkenSB:
			oarsCommand(command,Constants.OarsCommand2.IntrekkenSB)
		Constants.Command.IntrekkenBB:
			oarsCommand(command,Constants.OarsCommand2.IntrekkenBB)
		Constants.Command.HaalSB:
			changeState(command,Constants.RowState.HalenSB,1,false,true)
		Constants.Command.StrijkSB:
			changeState(command,Constants.RowState.StrijkenSB,-1,false,true)
		Constants.Command.HaalBB:
			changeState(command,Constants.RowState.HalenBB,1,false,true)
		Constants.Command.StrijkBB:
			changeState(command,Constants.RowState.StrijkenBB,-1,false,true)
		Constants.Command.Haal:
			changeState(command,Constants.RowState.HalenBeideBoorden,1,false,true)
		Constants.Command.Strijk:
			changeState(command,Constants.RowState.StrijkenBeidenBoorden,-1,false,true)
				
	lastCommand=command

	
func setLightPaddle(command :int,newLightPaddle:bool):
	var rules=getRules()
	var newValue=rules.determineLightPaddleState(self,command,newLightPaddle)
	if rules.error!="": showError(rules.error)
	else: lightPaddleOn=newValue

func endOneStroke():
	oneStroke=false
	doCommand(Constants.Command.Bedankt)
	
func setBest(command :int,newBestState :int):
	var rules=getRules()
	var newState=rules.determineBestState(self,command,newBestState)
	if rules.error!="": showError(rules.error)
	else: bestState= newState
	
func changeState(command:int,newState:int,direction:int,direct=false,doOneStroke=false):
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
	
	var slippenBB=stateOars==Constants.StateOars.SlippenBB || stateOars==Constants.StateOars.Slippen ;
	var slippenSB=stateOars==Constants.StateOars.SlippenSB || stateOars==Constants.StateOars.Slippen ;
	
		
	# for no rule sets go back to rowing state when pulled in
	if  oldState!=state && (stateOars==Constants.StateOars.IntrekkenBB || stateOars==Constants.StateOars.IntrekkenSB ) && !oarBB.pulledIn && !oarSB.pulledIn:
	   stateOars=Constants.StateOars.Roeien
	oneStroke=doOneStroke;
	
	var oneStokeFactor=1.0;
	if oneStroke:
		oneStokeFactor=0.6
	# going forward goes faster than backwards
	# change factor of Max speed, max rotat, speed inc,rotation inc
	# negative speed is backwards and negative turn speed is turn to the left
	match state:
		Constants.RowState.HalenBeideBoorden:
			setSpeedAndDirection(0.4*oneStokeFactor,0,1,false)
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
				if !slippenBB && !oarBB.pulledIn:
					oarBB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)
				if !slippenSB && !oarSB.pulledIn:
					oarSB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)

		Constants.RowState.Bedankt:
#			if abs(currentSpeed)<=lowNoRowingSpeed:
#				setSpeedAndDirection(0,0,0.2,false)
#			else: 
			setSpeedAndDirection(0,0,1,false)
			bestState=Constants.BestState.Normal;
			
			if !oarBB.pulledIn:
				if slippenBB:
					oarBB.setNewScheme(false,oarBB.rotation_slippen,oarBB.rotation_slippen,direct)
				else:
					oarBB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct,false,Constants.OarWaveState.Bedankt)
			if !oarSB.pulledIn:
				if slippenSB:
					oarSB.setNewScheme(false,oarBB.rotation_slippen,oarBB.rotation_slippen,direct)
				else:
					oarSB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct,false,Constants.OarWaveState.Bedankt)

		Constants.RowState.HalenSB:
			setSpeedAndDirection(0.35*oneStokeFactor,-0.3*oneStokeFactor,1,false)
			oarSB.setNewScheme(true,oarSB.rotation_inHalen,oarSB.rotation_out,direct)
			RimenHoogSetDisabledSB(false)
			#if !slippenBB:
			#	oarBB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct)

		Constants.RowState.HalenBB:
			setSpeedAndDirection(0.35*oneStokeFactor,0.3*oneStokeFactor,1,false)
			oarBB.setNewScheme(true,oarBB.rotation_inHalen,oarBB.rotation_out,direct)
			RimenHoogSetDisabledBB(false)
			#if !slippenSB:
			#	oarSB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct)
		Constants.RowState.VastroeienBeideBoorden:
			setSpeedAndDirection(0,0,0.4,false)
			if !slippenBB && !oarBB.pulledIn:
				oarBB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct,true,Constants.OarWaveState.Vastroeien)
			if !slippenSB && !oarSB.pulledIn:
				oarSB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct,true,Constants.OarWaveState.Vastroeien)
		Constants.RowState.VastroeienSB:
			setSpeedAndDirection(0,0.5,0.3,false)
			if !slippenSB:
				oarSB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct,false,Constants.OarWaveState.Vastroeien)
			RimenHoogSetDisabledSB(false)
		Constants.RowState.VastroeienBB:
			setSpeedAndDirection(0,-0.5,0.3,false)
			if !slippenBB && !oarBB.pulledIn:
				oarBB.setNewScheme(true,oarBB.rotation_rest,oarBB.rotation_rest,direct,false,Constants.OarWaveState.Vastroeien)
			if !slippenSB && !oarSB.pulledIn:
				oarSB.setNewScheme(false,oarBB.rotation_rest,oarBB.rotation_rest,direct)
			RimenHoogSetDisabledBB(false)
		Constants.RowState.StrijkenBeidenBoorden:
			setSpeedAndDirection(-0.4*oneStokeFactor,0,0.5,false)
			oarBB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct,true)
			oarSB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct,true)
			RimenHoogSetDisabledBB(false)
			RimenHoogSetDisabledSB(false)

		Constants.RowState.StrijkenBB:
			setSpeedAndDirection(-0.3*oneStokeFactor,-0.3*oneStokeFactor,0.5,false)
			oarBB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
			RimenHoogSetDisabledBB(false)
		Constants.RowState.StrijkenSB:
			setSpeedAndDirection(-0.3*oneStokeFactor,0.3*oneStokeFactor,0.5,false)
			oarSB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
			RimenHoogSetDisabledSB(false)
		Constants.RowState.PeddelendStrijkenBB:
			setSpeedAndDirection(0.1,-0.1,1,true)
			oarBB.setNewScheme(true,oarBB.rotation_slippen,oarBB.rotation_slippen_out,direct)
			RimenHoogSetDisabledBB(false)
		Constants.RowState.PeddelendStrijkenSB:
			setSpeedAndDirection(-0.1,0.1,1,true)
			oarSB.setNewScheme(true,oarBB.rotation_slippen,oarBB.rotation_slippen_out,direct)
			RimenHoogSetDisabledSB(false)
		Constants.RowState.UitzettenBB:
			onePush=true
			state=Constants.RowState.LaatLopen
			setSpeedAndDirection(50,0,1,true)
		Constants.RowState.UitzettenSB:
			onePush=true
			state=Constants.RowState.LaatLopen
			setSpeedAndDirection(-50,0,1,true)
		Constants.RowState.RondmakenBB:
			setSpeedAndDirection(0.01,-0.3,1,false)
			oarBB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
			oarSB.setNewScheme(false,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
			RimenHoogSetDisabledBB(false)

		Constants.RowState.RondmakenSB:
			setSpeedAndDirection(0.01,0.3,1,false)
			oarBB.setNewScheme(false,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
			oarSB.setNewScheme(true,oarBB.rotation_out,oarBB.rotation_inHalen,direct)
			RimenHoogSetDisabledSB(false)

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
			if oarBB.pulledIn:
				oarBB.doPullOut()
			elif oarSB.pulledIn:
				oarSB.doPullOut()
			else:
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
		Constants.StateOars.IntrekkenBB:
			oarBB.setNewScheme(false,oarBB.rotation_center,oarBB.rotation_center,direct)
			oarBB.doPullIn()
		Constants.StateOars.IntrekkenSB:
			oarSB.setNewScheme(false,oarSB.rotation_center,oarSB.rotation_center,direct)
			oarSB.doPullIn()
	if direct:
		updateOarCollision()
		
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
const ripple_min = 4
const ripple_max_trans = 0.49

func calcRippleEffect():
	var speed= linear_velocity.length()
	var ripple=$RippleEffect
	if calcSpeed()>ripple_min && !sideWays :
		ripple.playing=true
		ripple.visible=true
		ripple.modulate.a= (speed/40.0)*ripple_max_trans
	else:
		ripple.playing=false
		ripple.visible=false

func _introSignal(isVisible : bool):
	visible=!isVisible
	
