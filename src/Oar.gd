extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Oar

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

export var isSB = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

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
	if isSB: #mirror sb but keep source rotions the same
		rotation_degrees= mirrorRotation(newRotation)
	else:
		rotation_degrees=newRotation
	if slaveOar!=null:
		slaveOar.rotation_degrees=rotation_degrees
		slaveOar.inWater=inWater

	
