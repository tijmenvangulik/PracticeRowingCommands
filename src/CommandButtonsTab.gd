extends Tabs

class_name CommandButtonsTab

export (NodePath) onready var commandContainerSource = get_node(commandContainerSource) as GridContainer
export (NodePath) onready var commandContainerDest = get_node(commandContainerDest) as GridContainer

var customButtonSetChanged=false;

func _ready():
	GameEvents.connect("customButtonSetChangedSignal",self,"_customButtonSetChangedSignal")
	
func init():
	loadCommandSet()
	loadDestButtons()

func addGridGrouper(container):
	var grouper = preload("res://GridItemGrouper2.tscn").instance()
	grouper.visible=true
	container.add_child(grouper)	
	grouper.connect("button_droppedOnGrouper",self,"button_droppedOnGrouper")

	return grouper;
	
func addGridButton(container,commandName :String, isSource : bool):
	var buttonContainer = preload("res://GridButtonContainer.tscn").instance()
	container.add_child(buttonContainer)
	buttonContainer.visible=true;
	buttonContainer.canClickButton=false
	buttonContainer.init(commandName)
	buttonContainer.canDrag=true;
	if isSource:
		buttonContainer.connect("button_dropped",self,"button_dropped_source")
	else:
		buttonContainer.connect("button_dropped",self,"button_dropped_dest")
	return buttonContainer

	
func loadCommandSet():
	for i in range(0,Constants.commandNames.size()):
		var commandName=Constants.commandNames[i]
		addGridButton(commandContainerSource,commandName,true)
	
func clearDestGrid():
	for N in commandContainerDest.get_children():
		commandContainerDest.remove_child(N)
	enableDisableSourceButtons()


func loadDestButtons():
	clearDestGrid()
	
	var buttonSet=Settings.customButtonSet
	if buttonSet.size()==0:
		buttonSet=GameState.getDefaultButtonSet()
	for item in buttonSet:
		var grouper=addGridGrouper(commandContainerDest)
		
		var horiz=grouper.getHorizontalGroup()
		
		horiz.alignment=horiz.ALIGN_CENTER;
		if typeof(item)==TYPE_STRING:
			var commandNames=item.split(",")
			for buttonItem in commandNames:
				addGridButton(horiz,buttonItem,false)
	var totalGridItems=commandContainerDest.columns*5;
	for item in range(buttonSet.size(),totalGridItems):
		addGridGrouper(commandContainerDest)
	enableDisableSourceButtons()
	
func button_dropped_source(droppedInfo,dropped):
	if droppedInfo.dragButton.get_parent()!=commandContainerSource :
		droppedInfo.dragButton.get_parent().remove_child(droppedInfo.dragButton)
		customButtonSetChanged=true
		enableDisableSourceButtons()
	
func button_dropped_dest(droppedInfo,dropped):
	addGridButton(dropped.get_node(".."),droppedInfo.commandName,false)
	customButtonSetChanged=true
	enableDisableSourceButtons()
	
func button_droppedOnGrouper(droppedInfo,groupItem):
	addGridButton(groupItem.getHorizontalGroup(),droppedInfo.commandName,false)
	customButtonSetChanged=true
	enableDisableSourceButtons()
	

func _on_CommandContainerSource_button_droppedOnSourceGrid(droppedInfo):
	droppedInfo.dragButton.get_parent().remove_child(droppedInfo.dragButton)
	customButtonSetChanged=true
	enableDisableSourceButtons()
	
func enableDisableSourceButtons():
	var destDict=GetCustomButtonFlatDict()
	for  button in commandContainerSource.get_children():
		button.get_node("GridButton").disabled=destDict.has(button.commandName)
		
func updateCustomButtonSet():
	Settings.customButtonSet=[]
	for  grouper in commandContainerDest.get_children():
		var buttonNames=""		
		for  button in grouper.get_node("GridItemGrouperHoriz2").get_children():
			if buttonNames!="":
				buttonNames=buttonNames+","
			buttonNames=buttonNames+button.commandName
		Settings.customButtonSet.append(buttonNames)
	
func GetCustomButtonFlatDict():
	var result={}
	for  grouper in commandContainerDest.get_children():
		for  button in grouper.get_node("GridItemGrouperHoriz2").get_children():
			result[button.commandName]=1
	return result

func ensureButtonsetSaved():
	if customButtonSetChanged:
		updateCustomButtonSet()
		GameEvents.customButtonSetChanged()
		GameEvents.settingsChanged()


func _on_DefaultCustomButtons_pressed():
	Settings.customButtonSet=[]
	loadDestButtons();
	customButtonSetChanged=false
	GameEvents.customButtonSetChanged()
	GameEvents.settingsChanged()

	
func _on_ClearCustomButtons_pressed():
	Settings.customButtonSet=[]
	var totalGridItems=5*5;
	for item in range(1,5):
		Settings.customButtonSet.append("")
	loadDestButtons();
	customButtonSetChanged=true

func _customButtonSetChangedSignal():
	loadDestButtons();

func _on_SettingsDialog_visibility_changed():
	if visible:
		ensureButtonsetSaved()
	else:
		customButtonSetChanged=false
		loadDestButtons();
