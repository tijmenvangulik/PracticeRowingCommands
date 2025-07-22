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
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	

	
func calcShortCut(buttonText):
	customShortcut=Utilities.getCommandShortcut(command)
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
		setButtonTextFromCommand(changed_value)

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
	customTooltipText=Utilities.getCommandTooltip(command)
	var returnTooltip=""
	if customTooltipText!='' && !GameState.showTooltips:
		returnTooltip= customTooltipText
	else:
		var extension="_tooltip"
		if !GameState.showTooltips :
			extension="_shorttooltip";
		var tootipTextName=commandName+extension;
		var tootip=tr(tootipTextName)
			
		if tootip!=tootipTextName && tootip!="-":
			returnTooltip=tootip
	if shortcut!="" && GameState.showTooltips :
		if returnTooltip!="": 
			returnTooltip=returnTooltip+"\n"
		returnTooltip=returnTooltip+tr("Shortcut")+": "+shortcut
	
	return returnTooltip

func setButtonTextFromCommand(commandName):
	var altButtonCommandName=commandName+"_buttonOnly";
	var buttonResource=tr(altButtonCommandName)
	if buttonResource  && buttonResource!="-" && buttonResource!="" && buttonResource!=altButtonCommandName:
		setButtonText(buttonResource)
	else:
		setButtonText(commandName)
	var alterNativeText=Utilities.getCommandTranslation(command)
	if alterNativeText && alterNativeText!="":
		setButtonText(alterNativeText)
		
func init(newCommandName,enabled):
	commandName=newCommandName;
	GameEvents.register_allways_tooltip($GridButton,self,true)

	command=Utilities.commandNameToCommand(commandName)
	var button=$GridButton
	if command>=0:
		setButtonTextFromCommand(commandName)
		button.visible=true

		if  GameState.mobileMode:
			button.add_font_override("font",load("res://FontMobile.tres"))
		else:
			button.add_font_override("font",load("res://Font.tres"))
		
		setStyle()
	else:
		
		
		button.visible=false
	
	button.disabled=!enabled
	
	if GameState.mobileMode:
		#add more margin to botton for mobile
		$GridButton.margin_bottom=5
		self.rect_min_size.y=45
		self.rect_min_size.x=90
		
func setStyle():
	var button=$GridButton
	var styleNr= Constants.commandStyles[command]
	Styles.setButtonStyle(styleNr,button)
  
		
	

	
func _highContrastChangedSignal(highContrast):

	setStyle()
