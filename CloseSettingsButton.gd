extends Button

func _pressed():
	$"..".saveSettings()
	$"..".visible=false	
