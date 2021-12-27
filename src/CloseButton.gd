extends Button

func _pressed():
	$"..".visible=false	
	$"/root/World".setVisibleControlButtons(true)
