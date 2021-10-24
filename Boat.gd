extends KinematicBody2D

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO

var toRotation=0
var currentTurnSpeedFactor = 0.0
var currentSpeedFactor = 0.0

var max_speed = 60.0
var currentSpeed=0.0;
var speedIncFactor=1.0

var max_turn= 0.6
var currentTurnSpeed=0.0
var turnIncFactor=0.005

var lowTurnSpeed=10.0
var forceMultiplier=1.0
var turnMultiplier=1.0;	
var sideWays=false;
var lightPaddleFactor=0.5
var lightPaddleForceFactor=0.25
var lightPaddleTurnFactor=0.25
var lightPaddleDestTurnFactor=0.5
var lightPaddleOn=false

var speedDirectErrorLevel=15

enum RowState {HalenBeideBoorden,
  LaatLopen,Bedankt,HalenSB,StrijkenSB
  VastroeienSB,StrijkenBeidenBoorden,VastroeienBeideBoorden,
  HalenBB,StrijkenBB,VastroeienBB,
  PeddelendStrijkenBB,PeddelendStrijkenSB,
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
  LightPaddleBedankt
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
  "LightPaddleBedankt"
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
func _physics_process(delta):
	acceleration = Vector2.ZERO
	# get_input()
	# apply_friction()
	# calculate_steering(delta)
	
	# calc speed
	var forceCorrection=1.0
	if (lightPaddleOn): forceCorrection=lightPaddleFactor
	
	var destinationSpeed=currentSpeedFactor*max_speed*forceCorrection;
	var speedDiff=destinationSpeed-currentSpeed;
	if speedDiff>0: 
		currentSpeed+=speedIncFactor*forceMultiplier*lightPaddleForceFactor
		if currentSpeed>destinationSpeed:
			currentSpeed=destinationSpeed
		
	
	if speedDiff<0:
		currentSpeed-=speedIncFactor*forceMultiplier*lightPaddleForceFactor
		if currentSpeed<destinationSpeed:
			currentSpeed=destinationSpeed
	
	
	#calc rot
	var destinationTurnSpeed=currentTurnSpeedFactor*max_turn;
	
	#if currentSpeedFactor==0 && currentTurnSpeed!=0:
	#	turnIncFactor=turnIncFactor*(currentSpeedFactor/100)
	#else:
	
	var noturnLowSleed=state==RowState.VastroeienSB || state==RowState.VastroeienBB;
	
	if noturnLowSleed && currentTurnSpeed>0 && abs(currentSpeed)<lowTurnSpeed:
		destinationTurnSpeed=0
	
	var lightPaddleTurnMultiplier=1.0
	if lightPaddleOn:
		lightPaddleTurnMultiplier=lightPaddleTurnFactor
		destinationTurnSpeed=destinationTurnSpeed*lightPaddleDestTurnFactor
	
	var turnDiff=destinationTurnSpeed-currentTurnSpeed;
			
	if turnDiff>0 :
		currentTurnSpeed+=turnIncFactor*turnMultiplier*lightPaddleTurnMultiplier
		if currentTurnSpeed>destinationTurnSpeed:
			currentTurnSpeed=destinationTurnSpeed
		
	
	if turnDiff<0 :
		currentTurnSpeed-=turnIncFactor*turnMultiplier
		if currentTurnSpeed<destinationTurnSpeed:
			currentTurnSpeed=destinationTurnSpeed
	
	
	if noturnLowSleed &&  currentSpeed==0:
		currentTurnSpeed=0
		
	#var easeTurnSpeed=doEase(currentTurnSpeed,destinationTurnSpeed,-1.4);
	var easeTurnSpeed=currentTurnSpeed
	
	if currentSpeed<0: easeTurnSpeed=easeTurnSpeed*-1
		
	rotation += easeTurnSpeed * delta
	var sideWaysOffset=0
	if sideWays:
		if currentSpeedFactor<0 :
			sideWaysOffset=deg2rad(90);
		else: sideWaysOffset=deg2rad(-270)
	
	
	#apply easing	
	var easeSpeed=doEase(currentSpeed,max_speed,-1.2);
	
	velocity = Vector2(easeSpeed*delta, 0).rotated(rotation+sideWaysOffset)
	
	#velocity += acceleration * delta
	var collision = move_and_collide(velocity)
	if collision:
		currentSpeed=0
		changeState(RowState.LaatLopen,0)
		showError("Boem")
	
static func doEase(currentValue,maxValue,easing):
	#https://godotengine.org/qa/59172/how-do-i-properly-use-the-ease-function
	if maxValue==0: return 0
	maxValue=abs(maxValue)
	var easeValue=ease((abs(currentValue)*1.0)/maxValue,easing)*maxValue
	if (currentValue<0): easeValue=easeValue*-1
	return 	easeValue
	
static func apply_rotation_easing(from:float, to:float, easing:float, delta:float) -> float:
	var diff = wrapf(to - from, -PI, PI)
	var diff_norm = abs(diff)
	var angle_speed = ease(diff_norm / PI, easing)
	var angle_delta = angle_speed * delta
	if angle_delta > diff_norm:
		return to

	return from + angle_delta * sign(diff)
	
func setSpeedAndDirection(speedFactor:float,turnFactor:float,newForceMultiplier:float,newTurnMultiplier:float,newSideWays:bool):
	currentTurnSpeedFactor=turnFactor
	currentSpeedFactor=speedFactor
	forceMultiplier=newForceMultiplier
	turnMultiplier=newTurnMultiplier
	if sideWays!=newSideWays:
		currentSpeed=0.0
		currentTurnSpeed=0.0
	sideWays=newSideWays;
	
func boatInRest():
	return state==RowState.LaatLopen ||	state==RowState.Bedankt 	 || currentSpeed==0

func isLowSpeed(speed):
	return abs(speed)<speedDirectErrorLevel

func determinenewState(newState:int,direction:int):
	var result=state;
	
	if  ( stateOars==StateOars.RiemenHoogBB || stateOars==StateOars.RiemenHoogSB ):
	  stateOars=StateOars.Roeien

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
	else: if newState==RowState.Bedankt &&  !isLowSpeed(currentSpeed) && (state==RowState.HalenBeideBoorden ):
		showError("EerstLatenLopen")
		return result
	else: if newState==RowState.LaatLopen ||	newState==RowState.Bedankt 	 || currentSpeed==0:
		result=newState
		return result
	else:
		if state==RowState.LaatLopen || state==RowState.Bedankt:
			if isLowSpeed(currentSpeed): currentSpeed=0
			match direction:
				0:
					result=newState			
				1:
					if currentSpeed!=0:
						showError("LegBootStil")
					else:
						currentSpeed=0
						result=newState
				-1:
					if currentSpeed!=0:
						showError("LegBootStil")
					else:
						result=newState
				
		else:
			showError("EerstLatenLopenOfBedankt")
	if result!=state:
		prevError=""
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
			changeState(RowState.PeddelendStrijkenBB,0)
		Command.PeddelendStrijkenSB:
			changeState(RowState.PeddelendStrijkenSB,0)
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

	lastCommand=command
	
func setLightPaddle(newLightPaddle:bool):
	if newLightPaddle==lightPaddleOn:
		showError("CommandoNietMogelijk")
	else: lightPaddleOn=newLightPaddle

func changeState(newState:int,direction:int):
	
	state=determinenewState(newState,direction);  
	match state:
		RowState.HalenBeideBoorden:
			setSpeedAndDirection(1,0,1,1,false)
		RowState.LaatLopen:
			setSpeedAndDirection(0,0,0.1,1,false)
		RowState.Bedankt:
			setSpeedAndDirection(0,0,0.3,1,false)
		RowState.HalenSB:
			setSpeedAndDirection(0.35,-0.5,1,1,false)
		RowState.HalenBB:
			setSpeedAndDirection(0.35,0.5,1,1,false)
		RowState.VastroeienBeideBoorden:
			setSpeedAndDirection(0,0,1.5,1,false)
		RowState.VastroeienSB:
			if currentSpeed<0: setSpeedAndDirection(0,0.5,0.4,0.6,false)
			else : setSpeedAndDirection(0,0.6,0.4,0.6,false)
		RowState.VastroeienBB:
			if currentSpeed<0: setSpeedAndDirection(0,-0.5,0.4,0.4,false)
			else : setSpeedAndDirection(0,-0.6,0.4,0.4,false)
		RowState.StrijkenBeidenBoorden:
			setSpeedAndDirection(-0.4,0,0.5,1,false)
		RowState.StrijkenBB:
			setSpeedAndDirection(-0.3,0.3,0.5,1,false)
		RowState.StrijkenSB:
			setSpeedAndDirection(-0.3,-0.3,0.5,1,false)
		RowState.PeddelendStrijkenBB:
			setSpeedAndDirection(0.1,0.1,1,1,true)
		RowState.PeddelendStrijkenSB:
			setSpeedAndDirection(-0.1,-0.1,1,2,true)
		RowState.RondmakenBB:
			setSpeedAndDirection(0,-0.5,1,1,false)
		RowState.RondmakenSB:
			setSpeedAndDirection(0,0.5,1,1,false)

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
	setStateOars(newStateOars)
	rotation_degrees=newRotation
	position.x=x
	position.y=y
	lightPaddleOn=false
	currentSpeed=0
	currentTurnSpeed=0
	state=RowState.LaatLopen
	currentSpeedFactor=0
	currentTurnSpeedFactor=0
