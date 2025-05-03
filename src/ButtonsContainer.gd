extends PanelContainer

var enabled=true


func loadButtonsSetFromResources():
	var buttonSet=tr("ButtonSet")
	if buttonSet!=null && buttonSet!="ButtonSet" && buttonSet!="":
		
		var p= JSON.parse(buttonSet)
		if typeof(p.result)==TYPE_ARRAY:
			GameState.defaultButtonSet=p.result
			if GameState.useDefaultButtonSet:
				GameState.currentButtonSet=GameState.getDefaultButtonSet()
			
		
	
func initButtons():
	loadButtonsSetFromResources()
	loadButtons()

func _input(event):
	if !GameState.dialogIsOpen && event is InputEventKey and event.pressed:
		var focused_node = get_focus_owner()
		var findNext=false;
		var isGridNode=focused_node!=null && focused_node.find_parent("GridContainer")!=null
		if focused_node==null || focused_node.find_parent("RightTopButtons")!=null:
			var pressedChar=char(event.unicode).to_lower()
			if pressedChar!="":
				var button=focusFirstCommand()
				if button!=null:
					focused_node=button
					var command=button.find_parent("*GridButtonContainer*")
					findNext= command==null || command.shortcut!=pressedChar
				
		if findNext || isGridNode:
			var pressedChar=char(event.unicode).to_lower()
			if pressedChar!="":
				gotoNextButton(focused_node.find_parent("*GridButtonContainer*"),pressedChar)
				
func _ready():
	initButtons()
	GameEvents.connect("languageChangedSignal",self,"_languageChangedSignal");
	GameEvents.connect("disableCommandSignal",self,"_disableCommandSignal");
	GameEvents.connect("customButtonSetChangedSignal",self,"_customButtonSetChangedSignal")
	GameEvents.connect("showButtonsSignal",self,"_showButtonsSignal")
	GameEvents.connect("startPlay",self,"_startPlaySignal")

func setChildNodeText(node,commandName,value):
	for N in node.get_children():
		if N.get_child_count() > 0:
			setChildNodeText(N,commandName,value)
		else:
			if N.name=="GridButton" && N.owner.commandName==commandName:
				N.text=value

func setChildNodeDisable(node,commandName,disabled:bool):
	for N in node.get_children():
		if N.get_child_count() > 0:
			setChildNodeDisable(N,commandName,disabled)
		else:
			if N.name=="GridButton" && N.owner.commandName==commandName:
				N.disabled=disabled
				
				var button : Button=N
				if disabled:
					button.focus_mode=Control.FOCUS_NONE
				else:
					button.focus_mode=Control.FOCUS_ALL

func focusChildCommandFocus(node,commandName):
	for N in node.get_children():
		if N.get_child_count() > 0:
			focusChildCommandFocus(N,commandName)
		else:
			if N.name=="GridButton" && N.owner.commandName==commandName:
				N.grab_focus()
				
func disableCommand(commandName:String,disabled:bool):
	setChildNodeDisable($GridContainer,commandName,disabled)

func focusCommand(commandName:String):
	focusChildCommandFocus($GridContainer,commandName)

	
func clearGrid():
	var node=$"GridContainer"
	for N in node.get_children():
		node.remove_child(N)

func findNextFocus(skippNode,node :Node, allowBack = true):
	#find_next_valid_focus does not work when the node it selves does not have the focus
	var parent=node.get_parent();
	var children=parent.get_children();
	var index=node.get_index()
	if node==skippNode: index=index+1
	while (index<children.size()):
		var child : Node =children[index]
		if child is Button:
			var button : Button = child
			if !button.disabled:
				return button;
		else:
			if child.get_child_count()>0:
				var findChild= findNextFocus(skippNode,child.get_children()[0],false)
				if findChild!=null: return findChild
			
		index=index+1
	if allowBack:
		if parent==$GridContainer:
			 return findNextFocus(node,children[0],false)
	
		return findNextFocus(parent,parent)
	return null
	
func findNextButton(conainer :GridButtonContainer):
	var searchButton=conainer.get_node("GridButton")
	var nextFocusButton=findNextFocus(searchButton,searchButton)
	if nextFocusButton!=null:
		var result=nextFocusButton.get_parent() 
		if result is GridButtonContainer:
			return result
	return null
	
func gotoNextButton(button : GridButtonContainer,pressedChar : String):
	if GameState.dialogIsOpen:
		return
	var i=0;
	var buttonSet= GameState.currentButtonSet;
	var buttonCount=buttonSet.size()*2
	var found=false
	while i<buttonCount && !found && button!=null:
		button=findNextButton(button)
		if button!=null:
			var innerButton : Button=button.get_node("GridButton")			
			if !innerButton.disabled && pressedChar==button.shortcut:
				innerButton.grab_focus()
				found=true
		
		i=i+1
	pass
	
func _startPlaySignal():
	focusFirstCommand()

func focusFirstCommand():
	if GameState.dialogIsOpen:
		return null

	var button=findNextFocus($GridContainer,$GridContainer.get_children()[0],false)
	if button!=null:
		button.grab_focus()
	return button;
	
func buttonInput(event,button):
#	if !GameState.dialogIsOpen && event is InputEventKey && event.pressed:
#			var pressedChar=char(event.unicode).to_lower()
#			if pressedChar!="":
#				gotoNextButton(button,pressedChar)
	pass	

func addButton(container,commandName :String):
	var button = preload("res://GridButtonContainer.tscn").instance()
	container.add_child(button)
	button.visible=true;
	var innerButton=button.get_node("GridButton")
	innerButton.connect( "gui_input",self,"buttonInput",[button])
	button.init(commandName)

func forcePushAwayReplace(commandNames,forcePushAway,commandName):
	if forcePushAway==Constants.DefaultYesNo.Default:
		return commandName;
	if forcePushAway==Constants.DefaultYesNo.Yes:
		if commandName=="PeddelendStrijkenBB" && commandNames.find("UitzettenBB",0)<0:
			return "UitzettenBB"
		if commandName=="PeddelendStrijkenSB" && commandNames.find("UitzettenSB",0)<0:
			return "UitzettenSB"
	else:
		if commandName=="UitzettenBB" && commandNames.find("PeddelendStrijkenBB",0)<0:
			return "PeddelendStrijkenBB"
		if commandName=="UitzettenSB" && commandNames.find("PeddelendStrijkenSB",0)<0:
			return "PeddelendStrijkenSB" 
	return commandName

func forceSpinTurnReplace(commandNames,commandName):
	if commandName=="HalenSB" && commandNames.find("RondmakenSB",0)<0:
		return "RondmakenSB"
	if commandName=="HalenBB" && commandNames.find("RondmakenBB",0)<0:
		return "RondmakenBB"
	return commandName
	
func getAllConmmands():
	var allCommands=[]
	for item in GameState.currentButtonSet:
		if typeof(item)==TYPE_STRING:
			var commandNames=item.split(",")
			if commandNames.size()>1:
				for buttonItem in commandNames:
					allCommands.append(buttonItem)
			else: if commandNames.size()==1:
				var buttonItem=commandNames[0]
				allCommands.append(buttonItem)				
	return allCommands
	
func loadButtons(forcePushAway= Constants.DefaultYesNo.Default,forceSpinTurnReplace=false):
	clearGrid()
	var container =$"GridContainer"
	var i=0;
	var allCommands=getAllConmmands()
	for item in GameState.currentButtonSet:
		if typeof(item)==TYPE_STRING:
			var commandNames=item.split(",")
			if commandNames.size()>1:
				var box= HBoxContainer.new();
				box.alignment=box.ALIGN_CENTER;
				container.add_child(box)
				for buttonItem in commandNames:
					var newButtonItem=forcePushAwayReplace(allCommands,forcePushAway,buttonItem)
					if (forceSpinTurnReplace):
						newButtonItem=forceSpinTurnReplace(allCommands,newButtonItem)
					addButton(box,newButtonItem)
			else: if commandNames.size()==1:
				var buttonItem=commandNames[0]
				buttonItem=forcePushAwayReplace(allCommands,forcePushAway,buttonItem)
				if (forceSpinTurnReplace):
					buttonItem=forceSpinTurnReplace(allCommands,buttonItem)
				addButton(container,buttonItem)
		

func setCustomButtonSet(newButtonSet):
	if newButtonSet.size()==0: 
		GameState.currentButtonSet=GameState.getDefaultButtonSet()
		GameState.useDefaultButtonSet=true
	else: 
		GameState.currentButtonSet=newButtonSet
		GameState.useDefaultButtonSet=false
	loadButtons()

func _languageChangedSignal():
	initButtons()
	
func _disableCommandSignal(commandName:String,disabled:bool):
	disableCommand(commandName,disabled)

func _customButtonSetChangedSignal():
	setCustomButtonSet(Settings.customButtonSet)

func _showButtonsSignal(show : bool):
	visible=show
