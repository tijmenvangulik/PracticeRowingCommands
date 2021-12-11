extends PanelContainer

var defaultButtonSet=["HalenBeideBoorden","LaatLopen,Bedankt","VastroeienSB","HalenSB","StrijkenSB","StrijkenBeidenBoorden","VastroeienBeideBoorden","VastroeienBB","HalenBB","StrijkenBB","Slippen","SlippenSB","UitbrengenSB","PeddelendStrijkenSB","RondmakenSB","Uitbrengen","SlippenBB","UitbrengenBB","PeddelendStrijkenBB","RondmakenBB","LightPaddle","LightPaddleBedankt","RiemenHoogSB","RiemenHoogBB"]
var currentButtonSet=defaultButtonSet

func loadButtonsSetFromResources():
	var buttonSet=tr("ButtonSet")
	if buttonSet!=null && buttonSet!="ButtonSet" && buttonSet!="":
		var p= JSON.parse(buttonSet)
		if typeof(p.result)==TYPE_ARRAY:
			currentButtonSet=p.result
			defaultButtonSet=currentButtonSet

func commandIsUsed(commandName : String):
	var found=false

	for item in currentButtonSet:
		if item==commandName || item.begins_with(commandName+",") || item.find(","+commandName)>0:
			found=true
			break
			
	return found
	
func initButtons():
	loadButtonsSetFromResources()
	loadButtons()
	
func _ready():
	initButtons()
	
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
	for item in currentButtonSet:
		if typeof(item)==TYPE_STRING:
			var commandNames=item.split(",")
			if commandNames.size()>1:
				var box= HBoxContainer.new();
				container.add_child(box)
				for buttonItem in commandNames:
					addButton(box,buttonItem)
			else: if commandNames.size()==1:
				addButton(container,commandNames[0])

func setCustomButtonSet(newButtonSet):
	if newButtonSet.size()==0: currentButtonSet=defaultButtonSet
	else: currentButtonSet=newButtonSet
	loadButtons()
