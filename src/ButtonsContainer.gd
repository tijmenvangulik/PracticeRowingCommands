extends PanelContainer

func loadButtonsSetFromResources():
	var buttonSet=tr("ButtonSet")
	if buttonSet!=null && buttonSet!="ButtonSet" && buttonSet!="":
		
		var p= JSON.parse(buttonSet)
		if typeof(p.result)==TYPE_ARRAY:
			if GameState.useDefaultButtonSet:
				GameState.currentButtonSet=p.result
			GameState.defaultButtonSet=p.result

	
func initButtons():
	loadButtonsSetFromResources()
	loadButtons()
	
func _ready():
	initButtons()
	GameEvents.connect("languageChangedSignal",self,"_languageChangedSignal");
	GameEvents.connect("disableCommandSignal",self,"_disableCommandSignal");
	GameEvents.connect("customButtonSetChangedSignal",self,"_customButtonSetChangedSignal")
	GameEvents.connect("showButtonsSignal",self,"_showButtonsSignal")
	
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

func disableCommand(commandName:String,disabled:bool):
	setChildNodeDisable($GridContainer,commandName,disabled)
	
func clearGrid():
	var node=$"GridContainer"
	for N in node.get_children():
		node.remove_child(N)

	
func addButton(container,commandName :String):
	var button = preload("res://GridButtonContainer.tscn").instance()
	container.add_child(button)
	button.visible=true;
	button.init(commandName)
	
func loadButtons():
	clearGrid()
	var container =$"GridContainer"
	for item in GameState.currentButtonSet:
		if typeof(item)==TYPE_STRING:
			var commandNames=item.split(",")
			if commandNames.size()>1:
				var box= HBoxContainer.new();
				box.alignment=box.ALIGN_CENTER;
				container.add_child(box)
				for buttonItem in commandNames:
					addButton(box,buttonItem)
			else: if commandNames.size()==1:
				addButton(container,commandNames[0])

func setCustomButtonSet(newButtonSet):
	if newButtonSet.size()==0: 
		GameState.currentButtonSet=GameState.defaultButtonSet
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
