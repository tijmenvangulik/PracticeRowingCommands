extends Button

func _pressed():
	GameEvents.intro(false)
	GameEvents.startPlay()
