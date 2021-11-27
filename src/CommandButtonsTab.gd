extends Tabs

var customButtonSet=[]

var customButtonSetChanged=false;

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
	var boat=$"/root/World/Boat"
	var commandSelectGrid=$"CommandSelectScrollContainer/CommandContainerSource"
	for i in range(0,boat.commandNames.size()):
		var commandName=boat.commandNames[i]
		addGridButton(commandSelectGrid,commandName,true)

func clearDestGrid():
	var node=$"CommandSelectScrollContainerDest/CommandContainerDest"
	for N in node.get_children():
		node.remove_child(N)
		

func loadDestButtons():
	clearDestGrid()
	var container =$"CommandSelectScrollContainerDest/CommandContainerDest"	
	var buttonSet=customButtonSet
	var buttonContainer=$"/root/World/CanvasLayer/ButtonsContainer"
	if buttonSet.size()==0:
		buttonSet=buttonContainer.currentButtonSet
	for item in buttonSet:
		var grouper=addGridGrouper(container)
		var horiz=grouper.getHorizontalGroup()
		if typeof(item)==TYPE_STRING:
			var commandNames=item.split(",")
			for buttonItem in commandNames:
				addGridButton(horiz,buttonItem,false)
	var totalGridItems=container.columns*5;
	for item in range(buttonSet.size(),totalGridItems):
		addGridGrouper(container)
		
func button_dropped_source(droppedInfo,dropped):
	var sourceGrid=$CommandSelectScrollContainer/CommandContainerSource
	if droppedInfo.dragButton.get_parent()!=sourceGrid :
		droppedInfo.dragButton.get_parent().remove_child(droppedInfo.dragButton)
		customButtonSetChanged=true

func button_dropped_dest(droppedInfo,dropped):
	addGridButton(dropped.get_node(".."),dropped.commandName,false)
	customButtonSetChanged=true
	var grid=$CommandSelectScrollContainerDest/CommandContainerDest
	
func button_droppedOnGrouper(droppedInfo,groupItem):
	addGridButton(groupItem.getHorizontalGroup(),droppedInfo.commandName,false)
	customButtonSetChanged=true


func _on_CommandContainerSource_button_droppedOnSourceGrid(droppedInfo):
	droppedInfo.dragButton.get_parent().remove_child(droppedInfo.dragButton)
	customButtonSetChanged=true

func updateCustomButtonSet():
	customButtonSet=[]
	var grid =$"CommandSelectScrollContainerDest/CommandContainerDest"	
	for  grouper in grid.get_children():
		var buttonNames=""		
		for  button in grouper.get_node("GridItemGrouperHoriz2").get_children():
			if buttonNames!="":
				buttonNames=buttonNames+","
			buttonNames=buttonNames+button.commandName
		customButtonSet.append(buttonNames)
	

	
func _on_SettingsDialog_popup_hide():
	if customButtonSetChanged:
		updateCustomButtonSet()
		$"../../../ButtonsContainer".setCustomButtonSet(customButtonSet)
		$"../..".saveSettings()

func _on_SettingsDialog_about_to_show():
	customButtonSetChanged=false
	loadDestButtons();

func _on_DefaultCustomButtons_pressed():
	customButtonSet=[]
	loadDestButtons();
	customButtonSetChanged=false
	$"../../../ButtonsContainer".setCustomButtonSet(customButtonSet)
	$"../..".saveSettings()

	
func _on_ClearCustomButtons_pressed():
	customButtonSet=[]
	var totalGridItems=5*5;
	for item in range(1,5):
		customButtonSet.append("")
	loadDestButtons();
	customButtonSetChanged=true
	
