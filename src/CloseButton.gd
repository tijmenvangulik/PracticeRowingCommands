extends Button

func _pressed():
	$"%IntroDialog".closeIntro()
	$"%OptionStart".startOnWater()
