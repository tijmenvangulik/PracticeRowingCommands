extends MarginContainer

var commandName=""
var command=0;

func execCommand():
	var  boat=$"/root/World/Boat"
	boat.doCommand(command)
	
func init(newCommandName):
	var  boat=$"/root/World/Boat"
	commandName=newCommandName;
	command=boat.commandNameToCommand(commandName)
	
	if command>=0:
		var button=$GridButton
		button.text=commandName

		button.add_font_override("font",load("res://Font.tres"))
		
		var styleNr= boat.commandStyles[command]
		var style=null
		match styleNr:
			boat.CommandStyle.StyleButtonDarkGray:
				style = preload("res://StyleButtonDarkGray.tres")
			boat.CommandStyle.StyleButtonSB:
				style = preload("res://StyleButtonSB.tres")
			boat.CommandStyle.StyleButtonBB:
				style = preload("res://StyleButtonBB.tres")
			boat.CommandStyle.StyleButtonGray:
				 style= preload("res://StyleButtonGray.tres")
		button.add_stylebox_override("normal",style)
		
		match styleNr:
			boat.CommandStyle.StyleButtonDarkGray:
				style = preload("res://StyleButtonDarkGrayFocus.tres")
			boat.CommandStyle.StyleButtonSB:
				style = preload("res://StyleButtonSBFocus.tres")
			boat.CommandStyle.StyleButtonBB:
				style = preload("res://StyleButtonBBFocus.tres")
			_:
				 style= preload("res://StyleButtonGrayFocus.tres")	
		button.add_stylebox_override("focus",style)
		
		match styleNr:
			boat.CommandStyle.StyleButtonDarkGray:
				style = preload("res://StyleButtonDarkGrayPressed.tres")
			boat.CommandStyle.StyleButtonSB:
				style = preload("res://StyleButtonSBPressed.tres")
			boat.CommandStyle.StyleButtonBB:
				style = preload("res://StyleButtonBBPressed.tres")
			_:
				 style= preload("res://StyleButtonGrayPressed.tres")
		button.add_stylebox_override("pressed",style)
		
		match styleNr:
			boat.CommandStyle.StyleButtonDarkGray:
				style = preload("res://StyleButtonDarkGrayHover.tres")
			boat.CommandStyle.StyleButtonSB:
				style = preload("res://StyleButtonSBHover.tres")
			boat.CommandStyle.StyleButtonBB:
				style = preload("res://StyleButtonBBHover.tres")
			_:
				 style= preload("res://StyleButtonGrayHover.tres")	
		button.add_stylebox_override("hover",style)

		style= preload("res://ButtonDisabled.tres")
		button.add_stylebox_override("disabled",style)
		
