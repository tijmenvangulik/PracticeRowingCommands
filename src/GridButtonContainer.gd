extends MarginContainer
class_name GridButtonContainer

signal button_dropped(droppedInfo,droppedOn)

var commandName=""
var command=0;
var canClickButton=true
var canDrag=false;
var customTooltipText=""
var shortcut=""
var orgText=""
var customShortcut=""

func _ready():

	GameEvents.connect("customCommandTextChanged",self,"_on_EditCommandText_customCommandTextChanged")
	GameEvents.connect("customTooltipTextChanged",self,"_on_EditCommandText_customTooltipTextChanged")
	GameEvents.connect("customShortcutTextChanged",self,"_on_EditCommandText_customShortcutTextChanged")


func calcShortCut(buttonText):
	if customShortcut!="":
		shortcut=customShortcut
	else:
		var shortresourceName=commandName+"_shortcut"
		shortcut=tr(shortresourceName)
		#get the shortcut from the caption
		if shortcut=="" || shortcut==shortresourceName :
			shortcut=tr(buttonText).substr(0,1).to_lower()
	
func setButtonText(newText):
	orgText=newText
	calcShortCut(newText)
	if canClickButton && shortcut!="" && Settings.showShortCutsInButtons:
		$GridButton.text=tr(newText)+" "+shortcut
	else:
		$GridButton.text=newText
	
func _on_EditCommandText_customCommandTextChanged(changed_command,changed_commandName, changed_value):
	if  changed_command==command:
		var button=$GridButton
		setButtonText(changed_value)

func _on_EditCommandText_customShortcutTextChanged(changed_command,changed_commandName, changed_value):
	if  changed_command==command:
		customShortcut=changed_value
		if orgText!="":
			setButtonText(orgText)

		
func _on_EditCommandText_customTooltipTextChanged(changed_command,changed_commandName, changed_value):
	if  changed_command==command:
		customTooltipText=changed_value
	
func execCommand():
	if canClickButton && !GameState.isReplaying:
		GameEvents.doCommand(command)
		
func callButtonDropped(droppedInfo):
	emit_signal("button_dropped",droppedInfo,self)

func get_tooltip_text(node):
	if !GameState.showTooltips && !Settings.showCommandTooltips:
		return ""
	
	var returnTooltip=""
	if customTooltipText!='' && !GameState.showTooltips:
		returnTooltip= customTooltipText
	else:
		var extension="_tooltip"
		if !GameState.showTooltips :
			extension="_shorttooltip";
		var tootipTextName=commandName+extension;
		var tootip=tr(tootipTextName)
			
		if tootip!=tootipTextName:
			returnTooltip=tootip
	if shortcut!="" && GameState.showTooltips :
		if returnTooltip!="": 
			returnTooltip=returnTooltip+"\n"
		returnTooltip=returnTooltip+tr("Shortcut")+": "+shortcut
	
	return returnTooltip
	
func init(newCommandName):
	commandName=newCommandName;
	GameEvents.register_allways_tooltip($GridButton,self,true)

	command=Utilities.commandNameToCommand(commandName)
	if command>=0:
		var button=$GridButton
		var altButtonCommandName=commandName+"_buttonOnly";
		var buttonResource=tr(altButtonCommandName)
		if buttonResource && buttonResource!="" && buttonResource!=altButtonCommandName:
			setButtonText(buttonResource)
		else:
			setButtonText(commandName)
		var alterNativeText=Utilities.getCommandTranslation(command)
		if alterNativeText && alterNativeText!="":
			setButtonText(alterNativeText)
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


	
