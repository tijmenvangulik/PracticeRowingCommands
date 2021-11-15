extends Button

func _pressed():
	$"..".visible=false	
	$"../../OptionStart".visible=true
	$"../../OptionCommands".visible=true
	$"../../SettingsButton".visible=true
	
