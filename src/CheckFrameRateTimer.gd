extends Timer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var lowFrameRateCount=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_CheckFrameRateTimer_timeout() -> void:
	#print(Engine.get_frames_per_second())
	if GameState.isHighRes && !Settings.checkFrameRateDisabled:
		var frameRate=Engine.get_frames_per_second();
		if frameRate<45:
			lowFrameRateCount=lowFrameRateCount+1
		else:
			lowFrameRateCount=0
		if lowFrameRateCount>4:
			$"%LowFrameRateDialog".show()
