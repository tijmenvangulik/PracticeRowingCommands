extends MarginContainer

signal button_dropped(droppedInfo,droppedOn)

var commandName=""
var command=0;
var canClickButton=true
var canDrag=false;
var customTooltipText=""

func _ready():

	GameEvents.connect("customCommandTextChanged",self,"_on_EditCommandText_customCommandTextChanged")
	GameEvents.connect("customTooltipTextChanged",self,"_on_EditCommandText_customTooltipTextChanged")



func _on_EditCommandText_customCommandTextChanged(changed_command,changed_commandName, changed_value):
	if  changed_command==command:
		var button=$GridButton
		button.text=changed_value
		
func _on_EditCommandText_customTooltipTextChanged(changed_command,changed_commandName, changed_value):
	if  changed_command==command:
		customTooltipText=changed_value
	
func execCommand():
	if canClickButton:
		GameEvents.doCommand(command)
		
func callButtonDropped(droppedInfo):
	emit_signal("button_dropped",droppedInfo,self)

func get_tooltip_text(node):
	if !GameState.showTooltips && !Settings.showCommandTooltips:
		return ""

	if customTooltipText!='' && !GameState.showTooltips:
		return customTooltipText

	var extension="_tooltip"
	if !GameState.showTooltips :
		extension="_shorttooltip";
	var tootipTextName=commandName+extension;
	var tootip=tr(tootipTextName)
		
	if tootip!=tootipTextName:
		return tootip
	return ""
	
func init(newCommandName):
	commandName=newCommandName;
	GameEvents.register_allways_tooltip($GridButton,self)

	command=Utilities.commandNameToCommand(commandName)
	if command>=0:
		var button=$GridButton
		button.text=commandName
		var alterNativeText=Utilities.getCommandTranslation(command)
		if alterNativeText && alterNativeText!="":
			button.text=alterNativeText
		button.visible=true

		button.add_font_override("font",load("res://Font.tres"))
		
		var styleNr= Constants.commandStyles[command]
		var style=null
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = preload("res://StyleButtonDarkGray.tres")
			Constants.CommandStyle.StyleButtonSB:
				style = preload("res://StyleButtonSB.tres")
			Constants.CommandStyle.StyleButtonBB:
				style = preload("res://StyleButtonBB.tres")
			Constants.CommandStyle.StyleButtonGray:
				 style= preload("res://StyleButtonGray.tres")
		button.add_stylebox_override("normal",style)
		
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = preload("res://StyleButtonDarkGrayFocus.tres")
			Constants.CommandStyle.StyleButtonSB:
				style = preload("res://StyleButtonSBFocus.tres")
			Constants.CommandStyle.StyleButtonBB:
				style = preload("res://StyleButtonBBFocus.tres")
			_:
				 style= preload("res://StyleButtonGrayFocus.tres")	
		button.add_stylebox_override("focus",style)
		
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = preload("res://StyleButtonDarkGrayPressed.tres")
			Constants.CommandStyle.StyleButtonSB:
				style = preload("res://StyleButtonSBPressed.tres")
			Constants.CommandStyle.StyleButtonBB:
				style = preload("res://StyleButtonBBPressed.tres")
			_:
				 style= preload("res://StyleButtonGrayPressed.tres")
		button.add_stylebox_override("pressed",style)
		
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = preload("res://StyleButtonDarkGrayHover.tres")
			Constants.CommandStyle.StyleButtonSB:
				style = preload("res://StyleButtonSBHover.tres")
			Constants.CommandStyle.StyleButtonBB:
				style = preload("res://StyleButtonBBHover.tres")
			_:
				 style= preload("res://StyleButtonGrayHover.tres")	
		button.add_stylebox_override("hover",style)

		style= preload("res://ButtonDisabled.tres")
		button.add_stylebox_override("disabled",style)
	else:
		
		var button=$GridButton
		button.visible=false


	
