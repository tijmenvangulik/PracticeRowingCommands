extends RigidBody2D

var velocity = Vector2.ZERO

var toRotation=0
var currentTurnSpeedFactor = 0.0
var currentSpeedFactor = 0.0

var max_speed = 60.0
var currentSpeed=0.0;

var max_turn= 0.6
var currentTurnSpeed=0.0

var lowTurnSpeed=1.0
var forceMultiplier=1.0
var sideWays=false;
var lightPaddleFactor=0.5
var lightPaddleDestTurnFactor=0.5
var lightPaddleOn=false

var bestExtraRotation=2

enum BestState {Normal,StuurboordBest,BakboordBest}
var bestState : int= BestState.Normal
var lowNoRowingSpeed=lightPaddleFactor*max_speed

var speedDirectErrorLevel=10
var newRotation_degrees=-1.0;
var newPosition_x=-1.0
var newPosition_y=-1.0
var onePush=false;
var crashState=false;
enum RowState {HalenBeideBoorden,
  LaatLopen,Bedankt,HalenSB,StrijkenSB
  VastroeienSB,StrijkenBeidenBoorden,VastroeienBeideBoorden,
  HalenBB,StrijkenBB,VastroeienBB,
  PeddelendStrijkenBB,PeddelendStrijkenSB,
  UitzettenBB,UitzettenSB,
  RondmakenBB,RondmakenSB
}
var state:int = RowState.LaatLopen

enum OarsCommand {Slippen,Uitbrengen,
  SlippenSB,UitbrengenSB,
  SlippenBB,UitbrengenBB,
  RiemenHoogSB,RiemenHoogBB}

enum StateOars {Roeien,Slippen,SlippenSB,SlippenBB,RiemenHoogSB,RiemenHoogBB}

enum Command {
  LaatLopen,
  Bedankt,
  HalenBeideBoorden,
  HalenSB,
  HalenBB,
  StrijkenBeidenBoorden,
  StrijkenSB,
  StrijkenBB,
  VastroeienBeideBoorden,
  VastroeienSB,
  VastroeienBB,
  PeddelendStrijkenSB,
  PeddelendStrijkenBB,
  UitzettenSB,
  UitzettenBB,
  RondmakenSB,
  RondmakenBB,
  Slippen,
  SlippenSB,
  SlippenBB,
  RiemenHoogSB,
  RiemenHoogBB,
  Uitbrengen,
  UitbrengenSB,
  UitbrengenBB,
  LightPaddle,
  LightPaddleBedankt,
  StuurboordBest,
  BakboortBest,
  BestBedankt
}
var commandNames = [
  "LaatLopen",
  "Bedankt",
  "HalenBeideBoorden",
  "HalenSB",
  "HalenBB",
  "StrijkenBeidenBoorden",
  "StrijkenSB",
  "StrijkenBB",
  "VastroeienBeideBoorden",
  "VastroeienSB",
  "VastroeienBB",
  "PeddelendStrijkenSB",
  "PeddelendStrijkenBB",
  "UitzettenSB",
  "UitzettenBB",
  "RondmakenSB",
  "RondmakenBB",
  "Slippen",
  "SlippenSB",
  "SlippenBB",
  "RiemenHoogSB",
  "RiemenHoogBB",
  "Uitbrengen",
  "UitbrengenSB",
  "UitbrengenBB",
  "LightPaddle",
  "LightPaddleBedankt",
  "StuurboordBest",
  "BakboortBest",
  "BestBedankt"
]
var lastCommand=-1
var newCommand=-1
var stateOars = StateOars.Roeien

var prevError=""

func showError(message:String):
	if prevError!=message || lastCommand!=newCommand:
		var label=$"../CanvasLayer/errorLabel"
		label.text=tr(message)
		prevError=message
		#remove the error message after 2 secons
		var t = Timer.new()
		t.set_wait_time(2)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		label.text=""
		t.queue_free()

		
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
	currentSpeed=destinationSpeed
	
	#calc rot
	var destinationTurnSpeed=currentTurnSpeedFactor*max_turn;
	
	var noturnLowSleed=state==RowState.VastroeienSB || state==RowState.VastroeienBB;
	
	if noturnLowSleed && currentTurnSpeed>0 && abs(currentSpeed)<lowTurnSpeed:
		destinationTurnSpeed=0
	
	if lightPaddleOn:
		destinationTurnSpeed=destinationTurnSpeed*lightPaddleDestTurnFactor
	
	currentTurnSpeed=destinationTurnSpeed
	
		
	#var easeTurnSpeed=doEase(currentTurnSpeed,destinationTurnSpeed,-1.4);
	var easeTurnSpeed=currentTurnSpeed
		
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
	var absCurrentSpeed= abs(currentSpeed)
	if (destinationSpeed==0.0 and absCurrentSpeed>0.5 ):
		var extraTurnForce= Vector2(currentSpeed*0.02*forceMultiplier,0).rotated(angle+PI)
		apply_impulse(Vector2(0,25*sign(destinationTurnSpeed)).rotated(rotation),extraTurnForce)
	
	if bestState==BestState.StuurboordBest:
		apply_torque_impulse(-bestExtraRotation);
	else: if bestState==BestState.BakboordBest:
		apply_torque_impulse(bestExtraRotation);
	#check on colliding
	var collidingBodies=get_colliding_bodies()
	
	if collidingBodies.size()>0:
		changeState(RowState.LaatLopen,0)
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
	
	
func resetSpeedSideways():
	if !sideWays:
		currentSpeed=0.0
		currentTurnSpeed=0.0
	
func boatInRest():
	return state==RowState.LaatLopen ||	state==RowState.Bedankt 	 || isLowSpeed(linear_velocity.length())

func isLowSpeed(speed):
	return abs(speed)<speedDirectErrorLevel
	
func calcSpeed():
	var result=linear_velocity.length()
	var angle=abs(rad2deg( linear_velocity.angle()-rotation))
	if angle>170 && angle<190: result=result*-1
	return result
	
func determinenewState(newState:int,direction:int):
	var result=state;
	
	if stateOars==StateOars.Slippen &&  newState!=RowState.Bedankt && newState!=RowState.PeddelendStrijkenBB && newState!=RowState.PeddelendStrijkenSB :
		showError("CommandoNietMogelijk")	
		return result
	if stateOars!=StateOars.Roeien &&  stateOars!=StateOars.RiemenHoogSB && stateOars!=StateOars.RiemenHoogBB && (newState==RowState.HalenBeideBoorden || newState==RowState.StrijkenBeidenBoorden  || newState==RowState.RondmakenSB  || newState==RowState.RondmakenBB ):
		showError("EerstUitBrengen")	
		return result
	else: if stateOars==StateOars.SlippenBB && (newState==RowState.HalenBB || newState==RowState.StrijkenBB || newState==RowState.VastroeienBB):
		showError("EerstUitBrengen")	
		return result
	else: if stateOars==StateOars.SlippenSB && (newState==RowState.HalenSB || newState==RowState.StrijkenSB || newState==RowState.VastroeienSB) :
		showError("EerstUitBrengen")	
		return result
	else: if newState==RowState.PeddelendStrijkenSB && (stateOars!=StateOars.SlippenSB && stateOars!=StateOars.Slippen ):
		showError("EerstSlippen")	
		return result
	else: if newState==RowState.PeddelendStrijkenBB && (stateOars!=StateOars.SlippenBB && stateOars!=StateOars.Slippen ):
		showError("EerstSlippen")	
		return result
	else: if newState==RowState.Bedankt &&  !isLowSpeed(linear_velocity.length()) && (state==RowState.HalenBeideBoorden ):
		showError("EerstLatenLopen")
		return result
	else: if newState==RowState.UitzettenSB && stateOars!=StateOars.SlippenSB && stateOars!=StateOars.RiemenHoogSB:
		showError("CommandoNietMogelijk")
		return result	
	else: if newState==RowState.UitzettenBB && stateOars!=StateOars.SlippenBB && stateOars!=StateOars.RiemenHoogBB:
		showError("CommandoNietMogelijk")
		return result	
	else: if (newState==RowState.UitzettenSB || newState==RowState.UitzettenBB) && !isLowSpeed(linear_velocity.length()) :
		showError("LegBootStil")
		return result	
	else: if newState==RowState.LaatLopen ||	newState==RowState.Bedankt 	 || isLowSpeed(linear_velocity.length()):
		result=newState
		return result
	else:
		var currentDirection=0
		if calcSpeed()<0:  currentDirection=-1
		else: currentDirection=1
		if (state==RowState.LaatLopen || state==RowState.Bedankt)  :
			if  direction!=0 && direction!=currentDirection && !isLowSpeed(linear_velocity.length()):
				showError("LegBootStil")
				return result
			result=newState
				
		else:
			showError("EerstLatenLopenOfBedankt")
	
	return result;

func doCommand(command:int):
	newCommand=command	
	match command:
		Command.HalenBeideBoorden:
			changeState(RowState.HalenBeideBoorden,1)
		Command.LaatLopen:
			changeState(RowState.LaatLopen,0)
		Command.Bedankt:
			changeState(RowState.Bedankt,0)
		Command.HalenSB:
			changeState(RowState.HalenSB,1)
		Command.StrijkenSB:
			changeState(RowState.StrijkenSB,-1)
		Command.VastroeienSB:
			changeState(RowState.VastroeienSB,0)
		Command.StrijkenBeidenBoorden:
			changeState(RowState.StrijkenBeidenBoorden,-1)
		Command.VastroeienBeideBoorden:
			changeState(RowState.VastroeienBeideBoorden,0)
		Command.HalenBB:
			changeState(RowState.HalenBB,1)
		Command.StrijkenBB:
			changeState(RowState.StrijkenBB,-1)
		Command.VastroeienBB:
			changeState(RowState.VastroeienBB,0)
		Command.PeddelendStrijkenBB:
			resetSpeedSideways()
			changeState(RowState.PeddelendStrijkenBB,0)
		Command.PeddelendStrijkenSB:
			resetSpeedSideways()
			changeState(RowState.PeddelendStrijkenSB,0)
		Command.UitzettenBB:
			changeState(RowState.UitzettenBB,0)
		Command.UitzettenSB:
			changeState(RowState.UitzettenSB,0)
		Command.RondmakenBB:
			changeState(RowState.RondmakenBB,-1)
		Command.RondmakenSB:
			changeState(RowState.RondmakenSB,-1)
		Command.Slippen:
			oarsCommand(OarsCommand.Slippen)
		Command.Uitbrengen:
			oarsCommand(OarsCommand.Uitbrengen)
		Command.SlippenSB:
			oarsCommand(OarsCommand.SlippenSB)
		Command.UitbrengenSB:
			oarsCommand(OarsCommand.UitbrengenSB)
		Command.SlippenBB:
			oarsCommand(OarsCommand.SlippenBB)
		Command.UitbrengenBB:
			oarsCommand(OarsCommand.UitbrengenBB)
		Command.LightPaddle:
			setLightPaddle(true)
		Command.LightPaddleBedankt:
			setLightPaddle(false)
		Command.RiemenHoogSB:
			oarsCommand(OarsCommand.RiemenHoogSB)
		Command.RiemenHoogBB:
			oarsCommand(OarsCommand.RiemenHoogBB)
		Command.StuurboordBest:
			setBest(BestState.StuurboordBest)
		Command.BakboortBest:
			setBest(BestState.BakboordBest)
		Command.BestBedankt:
			setBest(BestState.Normal)
	lastCommand=command

func setBestState(newState : int):
	if (state!=RowState.HalenBeideBoorden):
		showError("CommandoNietMogelijk")
	else: 
		if newState!=BestState.Normal && bestState!=BestState.Normal:
			showError("CommandoNietMogelijk")
		else: bestState=	newState
	
func setLightPaddle(newLightPaddle:bool):
	if newLightPaddle==lightPaddleOn:
		showError("CommandoNietMogelijk")
	else: lightPaddleOn=newLightPaddle

func setBest(newBestState :int):
	if newBestState==BestState.Normal:
		if bestState!=BestState.StuurboordBest && bestState!= BestState.BakboordBest:
			showError("CommandoNietMogelijk")
		else:setBestState(newBestState)
	else:
		setBestState(newBestState) 

func changeState(newState:int,direction:int):
	var oldState=state
	#first check if the new state is allowed
	state=determinenewState(newState,direction); 
	if oldState!=state: 
		crashState=false;
		prevError=""
	#if the state change was successfull reset the oars state
	if  oldState!=state && (stateOars==StateOars.RiemenHoogBB || stateOars==StateOars.RiemenHoogSB ):
	  stateOars=StateOars.Roeien
 
	# going forward goes faster than backwards
	# change factor of Max speed, max rotat, speed inc,rotation inc
	# negative speed is backwards and negative turn speed is turn to the left
	match state:
		RowState.HalenBeideBoorden:
			setSpeedAndDirection(1,0,1,false)
		RowState.LaatLopen:
#			if abs(currentSpeed)<=lowNoRowingSpeed:
#				setSpeedAndDirection(0,0,0.001,false)
#			else: 
				setSpeedAndDirection(0,0,0.01,false)
		RowState.Bedankt:
#			if abs(currentSpeed)<=lowNoRowingSpeed:
#				setSpeedAndDirection(0,0,0.2,false)
#			else: 
				setSpeedAndDirection(0,0,1,false)
		RowState.HalenSB:
			setSpeedAndDirection(0.35,-0.5,1,false)
		RowState.HalenBB:
			setSpeedAndDirection(0.35,0.5,1,false)
		RowState.VastroeienBeideBoorden:
			setSpeedAndDirection(0,0,1.5,false)
		RowState.VastroeienSB:
			setSpeedAndDirection(0,0.6,0.4,false)
		RowState.VastroeienBB:
			setSpeedAndDirection(0,-0.6,0.4,false)
		RowState.StrijkenBeidenBoorden:
			setSpeedAndDirection(-0.4,0,0.5,false)
		RowState.StrijkenBB:
			setSpeedAndDirection(-0.3,-0.3,0.5,false)
		RowState.StrijkenSB:
			setSpeedAndDirection(-0.3,0.3,0.5,false)
		RowState.PeddelendStrijkenBB:
			setSpeedAndDirection(0.1,-0.1,1,true)
		RowState.PeddelendStrijkenSB:
			setSpeedAndDirection(-0.1,0.1,1,true)
		RowState.UitzettenBB:
			onePush=true
			state=RowState.LaatLopen
			setSpeedAndDirection(60,0,1,true)
		RowState.UitzettenSB:
			onePush=true
			state=RowState.LaatLopen
			setSpeedAndDirection(-60,0,1,true)
		RowState.RondmakenBB:
			setSpeedAndDirection(0.01,-0.5,1,false)
		RowState.RondmakenSB:
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
		StateOars.Roeien:
			$"Sprite".visible=true
			$"CollisionPolygon2D".disabled=false
		StateOars.Slippen:
			$"SpriteSlippen".visible=true
			$"CollisionSlippen".disabled=false
		StateOars.SlippenSB:
			$"SpriteSlippenSB".visible=true
			$"CollisionSlippenSB".disabled=false
			
		StateOars.SlippenBB:
			$"SpriteSlippenBB".visible=true
			$"CollisionSlippenBB".disabled=false
		StateOars.RiemenHoogSB:
			$"Sprite".visible=true
			$"CollisionRiemenHoogSB".disabled=false
		StateOars.RiemenHoogBB:
			$"Sprite".visible=true
			$"CollisionRiemenHoogBB".disabled=false

func oarsCommand(command: int):	
	if boatInRest():
		match command:
			OarsCommand.Slippen:
				if stateOars==StateOars.Roeien:
					setStateOars(StateOars.Slippen)
				else: 
					showError("CommandoNietMogelijk")
			OarsCommand.Uitbrengen:
				if stateOars==StateOars.Slippen:
					setStateOars(StateOars.Roeien)
				else:
					showError("CommandoNietMogelijk")
			OarsCommand.SlippenBB:
				
				if stateOars==StateOars.Roeien:
					setStateOars(StateOars.SlippenBB)
				else: if stateOars==StateOars.SlippenSB:
					setStateOars(StateOars.Slippen)
				else: showError("CommandoNietMogelijk")	
			OarsCommand.UitbrengenBB:
				if stateOars==StateOars.SlippenBB:
					setStateOars(StateOars.Roeien)
				else: if stateOars==StateOars.Slippen:
					setStateOars(StateOars.SlippenSB)
				else: showError("CommandoNietMogelijk")	
			OarsCommand.SlippenSB:
				if stateOars==StateOars.Roeien:
					setStateOars(StateOars.SlippenSB)
				else: if stateOars==StateOars.SlippenBB:
					setStateOars(StateOars.Slippen)
				else: showError("CommandoNietMogelijk")	
			OarsCommand.UitbrengenSB:
				if stateOars==StateOars.SlippenSB:
					setStateOars(StateOars.Roeien)
				else: if stateOars==StateOars.Slippen:
					setStateOars(StateOars.SlippenBB)
				else: showError("CommandoNietMogelijk")
			OarsCommand.RiemenHoogSB:
				if stateOars==StateOars.Roeien:
					setStateOars(StateOars.RiemenHoogSB)
				else: showError("CommandoNietMogelijk")	
				
			OarsCommand.RiemenHoogBB:					
				if stateOars==StateOars.Roeien:
					setStateOars(StateOars.RiemenHoogBB)
				else: showError("CommandoNietMogelijk")	
	else: 
		showError("EerstLatenLopenOfBedankt")
func setNewBoatPosition(x:int,y:int,newRotation,newStateOars : int):
	# reset the boat into a new position and place
	setStateOars(newStateOars)
	newRotation_degrees=newRotation
	newPosition_x=x
	newPosition_y=y
	lightPaddleOn=false
	bestState=BestState.Normal
	# reset speed or turn
	$"../CanvasLayer/ButtonsContainer".visible=true
	currentSpeed=0
	currentTurnSpeed=0
	state=RowState.LaatLopen
	currentSpeedFactor=0
	currentTurnSpeedFactor=0
