extends Button

func _pressed():
	GameEvents.settingsChanged()
	$"..".visible=false	
