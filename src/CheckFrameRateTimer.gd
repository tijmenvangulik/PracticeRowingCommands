extends Timer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


var sameFrameRateCount=0
var prefFrameRate=-1
var lowFrameRateCount=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

const lowFrameRate=45

func _on_CheckFrameRateTimer_timeout() -> void:
	#print(Engine.get_frames_per_second())
	if GameState.isHighRes && !Settings.checkFrameRateDisabled:
		var frameRate=Engine.get_frames_per_second();
		if frameRate>0:
			if prefFrameRate>=0 && frameRate>=prefFrameRate-1 && frameRate>=prefFrameRate-1:
				sameFrameRateCount=sameFrameRateCount+1
			else:
				sameFrameRateCount=0
			prefFrameRate=frameRate;
			if frameRate<lowFrameRate:
				lowFrameRateCount=lowFrameRateCount+1
			else:
				lowFrameRateCount=0
			# when the frame rate is low, but not the same each time
			# because in that case it is throtled by the low power mode and still a stable refresh rate
			if lowFrameRateCount>4 && sameFrameRateCount<4:
				$"%LowFrameRateDialog".show()
