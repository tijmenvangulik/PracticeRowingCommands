extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Oar

export (NodePath) onready var boat = get_node(boat) as Boat
var bladeWave : BladeWave = null;

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

func setNewScheme(startIsInNew : bool,startRotationNew  :float,endRotationNew,direct=false,syncBBandSBNew=false ):
	#set into a temp and swap when pssible
	newStartIsIn=startIsInNew
	newStartRotation=startRotationNew
	newEndRotation=endRotationNew
	newSchemeSet=true
	newSyncBBandSB=syncBBandSBNew
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
	#mirror sb
		
	if !frozen && (endRotation!=startRotation || currentRotation!=startRotation):
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
			
		
		var rot=boat.rotation_degrees+90
		
		var isSideWays=false
		if startRotation<endRotation:
			rot=rot+180
		if startRotation==rotation_slippen:
			isSideWays=true
			if isSB:
				rot=rot+80
			else:
				rot=rot-80
		startWave(rot,isSideWays)


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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


func startWave(rot,isSideways):
	var pos=$WavePosition.global_position
	if isSideways: 
		pos=$WavePositionStrijken.global_position

	bladeWave.startWave(pos,rot)
	if  slaveOar!=null:
		slaveOar.startWave(rot,isSideways)
	
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
