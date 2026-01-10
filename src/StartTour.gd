extends Button



# Called when the node enters the scene tree for the first time.

func _pressed():
	GameEvents.intro(false)
	GameEvents.startTour(true)
