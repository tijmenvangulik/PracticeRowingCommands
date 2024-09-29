extends Button

func _pressed():
	GameEvents.intro(false)
	$"%OptionStart".startOnWater()
