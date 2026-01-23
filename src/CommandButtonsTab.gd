extends Tabs

class_name CommandButtonsTab

export (NodePath) onready var commandContainerSource = get_node(commandContainerSource) as GridContainer
export (NodePath) onready var commandContainerDest = get_node(commandContainerDest) as GridContainer

var customButtonSetChanged=false;
var mobileLayout=false

func _ready():
	GameEvents.connect("customButtonSetChangedSignal",self,"_customButtonSetChangedSignal")
	GameEvents.connect("languageChangedSignal",self,"_languageChangedSignal");
	
	if GameState.mobileMode:
		mobileLayout=true
		$GridContainer/DestkopMobileSwitch.pressed=true
		$Label.text="DragButtonExplainMobile"
		commandContainerSource.columns=3
	else:
		GameEvents.register_allways_tooltip($GridContainer/DestkopMobileSwitch,"DestkopMobileSwitchTooltip")

func init():
	loadCommandSet()
	loadDestButtons()
	
func _languageChangedSignal():
	$GridContainer.margin_left=-200
	loadDestButtons()

func addGridGrouper(container):
	var grouper = preload("res://GridItemGrouper2.tscn").instance()
	grouper.visible=true
	container.add_child(grouper)	
	grouper.connect("button_droppedOnGrouper",self,"button_droppedOnGrouper")

	return grouper;
	
func addGridButton(container,commandName :String, isSource : bool,insertIndex):
	var buttonContainer = preload("res://GridButtonContainer.tscn").instance()
	container.add_child(buttonContainer)
	if insertIndex!=null:
		container.move_child(buttonContainer,insertIndex)

	buttonContainer.visible=true;
	buttonContainer.canClickButton=false
	buttonContainer.init(commandName,true)
	buttonContainer.canDrag=true;
	
	if isSource:
		buttonContainer.connect("button_dropped",self,"button_dropped_source")
	else:
		buttonContainer.connect("button_dropped",self,"button_dropped_dest")
	return buttonContainer

	
func loadCommandSet():
	for i in range(0,Constants.commandNames.size()):
		var commandName=Constants.commandNames[i]
		addGridButton(commandContainerSource,commandName,true,null)
	
func clearDestGrid():
	for N in commandContainerDest.get_children():
		commandContainerDest.remove_child(N)
	enableDisableSourceButtons()


func loadDestButtons():
	clearDestGrid()
	if mobileLayout:
		commandContainerDest.columns=1
	else:
		commandContainerDest.columns=5
		
	var buttonSet=Settings.customButtonSet
	if mobileLayout:
		if Settings.customButtonSetMobile.size()>0:
			buttonSet=Settings.customButtonSetMobile
		if buttonSet==null || buttonSet.size()==0:
			var mobileSet=Utilities.getDefaultJsonSetting("ButtonSetMobile")
			if mobileSet!=null && mobileSet.size()>0:
				buttonSet=mobileSet
	
	if buttonSet.size()==0:
		buttonSet=GameState.getDefaultButtonSet()
	var cnt=0
	for item in buttonSet:
		var commandNames=[]
		if typeof(item)==TYPE_STRING:
			commandNames=item.split(",")
		var allEmpty=true
		for buttonName in commandNames:
			if buttonName!=null && buttonName!="":
				allEmpty=false
				break
		if !allEmpty || !mobileLayout:
			var grouper=addGridGrouper(commandContainerDest)
			
			var horiz=grouper.getHorizontalGroup()
			
			horiz.alignment=horiz.ALIGN_CENTER;
			if commandNames.size()>0:
				for buttonItem in commandNames:
					addGridButton(horiz,buttonItem,false,null)
			cnt=cnt+1
	
	if mobileLayout:
		var totalGridItems=5*4;
		while cnt< totalGridItems:
			var grouper=addGridGrouper(commandContainerDest)
			var horiz=grouper.getHorizontalGroup()			
			horiz.alignment=horiz.ALIGN_CENTER;
			cnt=cnt+1
	else:
		var totalGridItems=commandContainerDest.columns*5;
		for item in range(buttonSet.size(),totalGridItems):
			addGridGrouper(commandContainerDest)
		
	enableDisableSourceButtons()

func getParentGrid(item):
	var grid=item.get_parent()
	if !(grid is GridContainer):
		grid=grid.get_parent()
	return grid;
	
func button_dropped_source(droppedInfo,dropped):
	var grid=getParentGrid(droppedInfo.dragButton)
	if grid!=commandContainerSource :
		droppedInfo.dragButton.get_parent().remove_child(droppedInfo.dragButton)
	customButtonSetChanged=true
	enableDisableSourceButtons()
	
func button_dropped_dest(droppedInfo,dropped):
	var beforeIndex=dropped.get_index()

	if droppedInfo.dragButton!=dropped:
		var grid=getParentGrid(droppedInfo.dragButton)
		if grid!=commandContainerSource:
			droppedInfo.dragButton.get_parent().remove_child(droppedInfo.dragButton)
		addGridButton(dropped.get_node(".."),droppedInfo.commandName,false,beforeIndex)
		customButtonSetChanged=true
		enableDisableSourceButtons()
	
func button_droppedOnGrouper(droppedInfo,groupItem):
	var grid=getParentGrid(droppedInfo.dragButton)
	if grid!=commandContainerSource:
		droppedInfo.dragButton.get_parent().remove_child(droppedInfo.dragButton)
	addGridButton(groupItem.getHorizontalGroup(),droppedInfo.commandName,false,null)
	customButtonSetChanged=true
	enableDisableSourceButtons()
	

func _on_CommandContainerSource_button_droppedOnSourceGrid(droppedInfo):
	droppedInfo.dragButton.get_parent().remove_child(droppedInfo.dragButton)
	customButtonSetChanged=true
	enableDisableSourceButtons()
	
func enableDisableSourceButtons():
	var destDict=GetCustomButtonFlatDict()
	var sourceButtons=commandContainerSource.get_children()
	for  button in sourceButtons:
		var disabled=destDict.has(button.commandName)
		button.get_node("GridButton").disabled=disabled
		
func updateCustomButtonSet():
	var buttonsSet=[]
	for  grouper in commandContainerDest.get_children():
		var buttonNames=""		
		for  button in grouper.get_node("GridItemGrouperHoriz2").get_children():
			if buttonNames!="":
				buttonNames=buttonNames+","
			buttonNames=buttonNames+button.commandName
		buttonsSet.append(buttonNames)
	if mobileLayout:
		Settings.customButtonSetMobile=buttonsSet
	else:
		Settings.customButtonSet=buttonsSet
	customButtonSetChanged=false
		
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
	if mobileLayout:
		Settings.customButtonSetMobile=[]
	else:
		Settings.customButtonSet=[]
	loadDestButtons();
	customButtonSetChanged=false
	GameEvents.customButtonSetChanged()
	GameEvents.settingsChanged()

	
func _on_ClearCustomButtons_pressed():
	var buttonsSet=[]
	for item in range(1,5):
		buttonsSet.append("")
		
	if mobileLayout:
		Settings.customButtonSetMobile=buttonsSet
	else:
		Settings.customButtonSet=buttonsSet
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


func _on_DestkopMobileSwitch_toggled(button_pressed: bool) -> void:
	ensureButtonsetSaved()
	mobileLayout=button_pressed
	loadDestButtons()
