extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Oar

export (NodePath) onready var boat = get_node(boat) as Boat
var bladeWave : BladeWave = null;
var collision : CollisionPolygon2D = null

var masterOar :Oar =null

var slaveOar :Oar =null
var otherSideOar = null

const rotation_out = -137.6 #=-150.3
const rotation_in= -29.8
const rotation_inHalen = -60
const rotation_center=-90
const rotation_rest=-93
const rotation_slippen=-166
const rotation_slippen_out=-156.6

const angleSpeed=40


var inWater=false
var oarsMoving =false

var startRotation=rotation_rest
var startIsIn=false
var endRotation=rotation_rest
var frozen=false
var destinationRotation=rotation_rest
var normalRotation

enum MoveInOutOarDirection {None,In,Out}
var moveOarInOut = MoveInOutOarDirection.None
 
export var isSB = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func isRowing():
	return !frozen && startRotation!=newEndRotation
	
func mirrorRotation(rot):
	rot=180-rot
	if rot>0:
		rot=rot-360 
	return rot

var newSchemeSet=false
var newStartIsIn =false
var newStartRotation =0.0
var newEndRotation=0.0
var newSyncBBandSB=false
var syncBBandSB=false
var pullIn=false
var pulledIn=false
var pullSpeed=40
var waveState= Constants.OarWaveState.None
var newWaveState=Constants.OarWaveState.None

func setNewScheme(startIsInNew : bool,startRotationNew  :float,endRotationNew,direct=false,syncBBandSBNew=false,waveStateNew  = Constants.OarWaveState.None ):
	#set into a temp and swap when pssible
	newStartIsIn=startIsInNew
	newStartRotation=startRotationNew
	newEndRotation=endRotationNew
	newSchemeSet=true
	newSyncBBandSB=syncBBandSBNew
	newWaveState=waveStateNew
	if direct:
		swapFromNewScheme()		
		setRotation(endRotationNew)
		frozen=true
		
		resetPullIn()
		if slaveOar!=null:
			slaveOar.resetPullIn()
	
func resetPullIn():
	pulledIn=false
	if isSB:
		position.y=20
	else:
		position.y=-20

func swapFromNewScheme():
	startIsIn=newStartIsIn
	startRotation=newStartRotation
	endRotation=newEndRotation
	destinationRotation=newStartRotation
	newSchemeSet=false
	syncBBandSB=newSyncBBandSB
	waveState=newWaveState
	slaveOar.waveState=newWaveState
	#if startRotationNew>endRotation:
	frozen=false
	if !isRotation(startRotation):
		inWater=false
	
func freeze():
	frozen=true
		
func setImage():
	
	if $"SpriteInWater".visible!=inWater:
		$"SpriteInWater".visible=inWater
		$"Sprite".visible=!inWater
	
func calcNewRotation(delta,currentRotation : float):
	var newRotation=currentRotation
	var rotationStep=delta*angleSpeed;
	oarsMoving=false
	#mirror sb
		
	if !frozen && (endRotation!=startRotation || currentRotation!=startRotation):
		oarsMoving=true
		if pulledIn:
			doPullOut()
			return currentRotation
			
		var lcoalOarsGoForwards= currentRotation<destinationRotation
		
		if lcoalOarsGoForwards:
			newRotation+=rotationStep
			if newRotation>destinationRotation:
				# in case of an overshoot
				if currentRotation<destinationRotation:
					newRotation=destinationRotation
				setInWater()
				#swap direction
				if destinationRotation==startRotation:
					destinationRotation=endRotation
				else :
					destinationRotation=startRotation
		else:
			newRotation-=rotationStep
			if newRotation<destinationRotation:
				# in case of an overshoot				
				if currentRotation>destinationRotation:
					newRotation=destinationRotation
				
				#swap direction
				setInWater()
				if destinationRotation==startRotation:
					destinationRotation=endRotation
				else :
					destinationRotation=startRotation
	else:
		setInWater()
	
	return newRotation

func setInWater():
	if destinationRotation==startRotation:
		inWater=startIsIn
	else:
		inWater=!startIsIn
		if startIsIn && boat.oneStroke:
			boat.endOneStroke()
			
		calcWave(true,0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var oldInWater=inWater
	if newSchemeSet && (!inWater || frozen || startRotation==endRotation ) :		 
			swapFromNewScheme()
	if normalRotation==null: 
		normalRotation=rotation_degrees
	
	if masterOar==null:
		normalRotation=calcNewRotation(delta,normalRotation)
	else:
		normalRotation=getNormalRoation(masterOar.rotation_degrees)
		inWater=masterOar.inWater
	
	rotation_degrees=getNormalRoation(normalRotation)
	
	# both oars wait on each other to go in sync
	if syncBBandSB:
		if normalRotation==startRotation : 
			frozen=true
			if otherSideOar.normalRotation==startRotation  || !otherSideOar.syncBBandSB :
				frozen=false
				syncBBandSB=false
				otherSideOar.frozen=false
				otherSideOar.syncBBandSB=false
	if normalRotation==rotation_center && pullIn!=pulledIn:
		handlePullIn(delta)


	setImage()
	if inWater && oarsMoving:
		if oldInWater:
			calcWave(false,delta)
		else:
			calcWave(false,0)
	var bedanktState= !boat.isStopped() && waveState==Constants.OarWaveState.Bedankt && !collision.disabled
	var bedanktWave=$Wave_Bedankt

	if bedanktWave.visible!=bedanktState:
		bedanktWave.visible=bedanktState
		if boat.movingBackwards():
			bedanktWave.rotation_degrees=0
		else:
			bedanktWave.rotation_degrees=-180
		if bedanktState:
			bedanktWave.play()
		else: 
			bedanktWave.stop()
#		bedanktWave.playings=bedanktState;
		
	var vastroeienState= !boat.isStopped() && waveState==Constants.OarWaveState.Vastroeien
	var vastRoeienWave=$Wave_Vastroeien
	if vastRoeienWave.visible!=vastroeienState:
		vastRoeienWave.visible=vastroeienState
		if boat.movingBackwards():
			vastRoeienWave.rotation_degrees=0
		else:
			vastRoeienWave.rotation_degrees=-180
		if vastroeienState:
			vastRoeienWave.play()
		else: 
			vastRoeienWave.stop()

func isRotation(checkRotation):
	var currentRotation= getNormalRoation(rotation_degrees)
	var result= currentRotation==checkRotation
	return result

func getNormalRoation(rot):
	if isSB: #mirror sb but keep source rotions the same
		return mirrorRotation(rot)
	else:
		return rot

func setRotation(newRotation):
	normalRotation=newRotation

	if isSB: #mirror sb but keep source rotions the same
		rotation_degrees= mirrorRotation(newRotation)
	else:
		rotation_degrees=newRotation
	if slaveOar!=null:
		slaveOar.rotation_degrees=rotation_degrees
		slaveOar.inWater=inWater

func doPullIn():
	pullIn=true;

	
func doPullOut():	
	pullIn=false;


func calcWave(isEndWave : bool,delta):
	var isSideWays=false
	var isStrijken=false
	var rot=boat.rotation_degrees+90
	if newStartIsIn:
		if startRotation<endRotation:
			rot=rot+180
			isStrijken=true
	else:
		if startRotation>endRotation:
			rot=rot+180
			isStrijken=true
		
	if startRotation==rotation_slippen:
		isSideWays=true
		delta=delta*1.5
		if isSB:
			rot=rot+80
		else:
			rot=rot-80
	else:
		delta=delta/2
	startWave(rot,isSideWays,isEndWave,isStrijken,delta)
	
func startWave(rot,isSideways,isEnd,isStrijken,delta):
	var pos=$WavePosition.global_position
	if isSideways || isStrijken: 
		pos=$WavePositionStrijken.global_position
	if visible:
		bladeWave.startWave(pos,rot,isEnd,delta)
			
	if delta==0 && !isEnd && !isSideways : 
		$BladeSplash.startSplash(isStrijken)
		
	if  slaveOar!=null:
		slaveOar.startWave(rot,isSideways,isEnd,isStrijken,delta)

func handlePullIn(delta):	
	var diff=pullSpeed*delta*(-1 if pullIn else 1)*(1 if isSB else -1)
	position.y+=diff
	
	if pullIn:
		if isSB && position.y<-10:
			position.y=-10
			pulledIn=true
		elif !isSB && position.y>10:
			position.y=10
			pulledIn=true
	else:
		if isSB && position.y>20:
			position.y=20
			pulledIn=false
		elif !isSB && position.y<-20:
			position.y=-20
			pulledIn=false
	if slaveOar!=null:
		slaveOar.position.y=position.y
		slaveOar.pulledIn=pulledIn
		slaveOar.pullIn=pullIn
