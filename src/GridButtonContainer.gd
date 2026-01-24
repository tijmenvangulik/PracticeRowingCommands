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
	shortcut=Utilities.calcShortCut(command,commandName,buttonText)
	
	
func setButtonText(newText):
	orgText=newText
	calcShortCut(newText)
	if canClickButton && shortcut!="" && Settings.showShortCutsInButtons:
		$GridButton.text=tr(newText)+" "+shortcut
	else:
		$GridButton.text=newText
	rect_min_size.x=0
	var parent=get_parent()
	if parent!=null:
		parent.rect_min_size.x=0
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

func calcClickableButtonTooltip():
	var returnTooltip=""
	customTooltipText=Utilities.getCommandTooltip(command)
	
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
	
func get_tooltip_text(node):
	if (!canDrag && GameState.mobileMode )|| ( !GameState.showTooltips && !Settings.showCommandTooltips ) :
		return ""
# for drag drop use the normal whole command as tooltip	
	if canDrag:
		var returnTooltip=""
		returnTooltip=Utilities.getCommandTextTranslation(command)
		if returnTooltip==tr($GridButton.text):
			returnTooltip=""
		return returnTooltip
	if canClickButton:
		return calcClickableButtonTooltip()
	return ""

	
func setButtonTextFromCommand(commandName):
	var text=Utilities.calcButtonTextFromCommand(commandName,command)
	setButtonText(text)
		
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
	
func can_drop_data(_pos, data):
	var dragButtonParent=data.dragButton.get_parent()
	var grid=self.get_parent()
	return typeof(data) == TYPE_DICTIONARY && data["command"]!=null && dragButtonParent!=grid

func drop_data(_pos, data):
	get_parent().emit_signal("button_droppedOnSourceGrid",data)
