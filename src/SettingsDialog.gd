extends WindowDialog

class_name SettingsDialog
#RuleSets
export (NodePath) onready var rulesetManager = get_node(rulesetManager) as RuleSets
export (NodePath) onready var ruleSetDropDown = get_node(ruleSetDropDown) as OptionButton
export (NodePath) onready var commandTranslationsGrid = get_node(commandTranslationsGrid) as GridContainer
export (NodePath) onready var commandTranslationsHeaderGrid = get_node(commandTranslationsHeaderGrid) as GridContainer
export (NodePath) onready var commandTranslationsCommandsGrid = get_node(commandTranslationsCommandsGrid) as GridContainer

export (NodePath) onready var showCommandTooltips = get_node(showCommandTooltips) as Button

export (NodePath) onready var commandButtonsTab = get_node(commandButtonsTab) as CommandButtonsTab

export (NodePath) onready var showShortCutsInButtons = get_node(showShortCutsInButtons) as Button
export (NodePath) onready var isScullButton = get_node(isScullButton) as Button

export (NodePath) onready var enablePracticesTab = get_node(enablePracticesTab) as EnablePracticesTab 
export (NodePath) onready var resolutionButton = get_node(resolutionButton) as OptionButton 


var settingsFile="user://settings.save"

func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");

func addLabel(container,text):
	var new_label = Label.new()
	new_label.text=text
	new_label.add_font_override("font",load("res://Font.tres"))
	container.add_child(new_label)
	return new_label

func addLabelCommandsGrid(container,text):
	var labelPanel = preload("res://DisplayHeaderCommand.tscn").instance()
	var label=labelPanel.get_node("Label")
	label.text=text
	container.add_child(labelPanel)
	labelPanel.visible=true
	return label
	
func loadRulesets():
	var ruleSets=rulesetManager.getRulesets()
	
	var i=0
	for ruleSet in ruleSets:
		ruleSetDropDown.add_item(ruleSet,i)
		i=i+1

func _on_RuleSetDropDown_item_selected(index):
	var ruleSets=rulesetManager.getRulesets()
	var ruleSet=ruleSets[index];
	rulesetManager.setRuleset(ruleSet)
	saveSettings()

func setRuleset(ruleset):
	var ruleSets=rulesetManager.getRulesets()
	rulesetManager.setRuleset(ruleset)
	var index=ruleSets.find(ruleset)
	if index>=0:
		ruleSetDropDown.select(index)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("customCommandTextChanged",self,"_on_EditCommandText_customCommandTextChanged")
	GameEvents.connect("customCommandText2Changed",self,"_on_EditCommandText_customCommandText2Changed")
	GameEvents.connect("customTooltipTextChanged",self,"_on_EditTooltipText_customTooltipTextChanged")
	GameEvents.connect("customShortcutTextChanged",self,"_on_EditTooltipText_customShortcutTextChanged")
	GameEvents.connect("settingsChangedSignal",self,"_handleSettingsChanged")
	
	var pushAwayOption=$TabContainer/GeneralSettingsTab/GridContainer/UsePushAwayOption
	pushAwayOption.add_item("Default",Constants.DefaultYesNo.Default)
	pushAwayOption.add_item("Yes",Constants.DefaultYesNo.Yes)
	pushAwayOption.add_item("No",Constants.DefaultYesNo.No)
	
	get_close_button().hide()
	
	GameEvents.register_allways_tooltip($TabContainer/GeneralSettingsTab/GridContainer/ShowShortCutsInButtons,"ShortCutTourText")
	GameEvents.register_allways_tooltip($TabContainer/GeneralSettingsTab/GridContainer/Scull,"ScullTooltip")
	
	Utilities.styleDropDown($TabContainer/GeneralSettingsTab/GridContainer/RuleSetDropDown)
	Utilities.styleDropDown($ChoosePresetSettingsButton)
	Utilities.styleDropDown(resolutionButton)
	
	var commands=Constants.commandNames
	while Settings.commandTranslations.size()<commands.size():
		Settings.commandTranslations.push_back("")
		
	while Settings.tooltipTranslations.size()<commands.size():
		Settings.tooltipTranslations.push_back("")
		
	while Settings.shortcutTranslations.size()<commands.size():
		Settings.shortcutTranslations.push_back("")
	
	while Settings.commandTextTranslations.size()<commands.size():
		Settings.commandTextTranslations.push_back("")
	# wait till all readies are called	
	yield(get_tree(), "idle_frame")
	
	loadRulesets();
	
	loadSettings()
	
	GameEvents.settingsLoaded()

	pushAwayOption.select(Settings.usePushAway)
	
	#https://www.tilcode.com/godot-3-centering-a-grid-of-evenly-spaced-buttons-on-screen/
	#https://docs.godotengine.org/en/stable/getting_started/step_by_step/ui_game_user_interface.html
	var commandIndex=0;
#	addLabelCommandsGrid(commandTranslationsHeaderGrid,"Commando")
	addLabelCommandsGrid(commandTranslationsHeaderGrid,"ButtonText")
	addLabelCommandsGrid(commandTranslationsHeaderGrid,"FullCommand")
	addLabelCommandsGrid(commandTranslationsHeaderGrid,"Tooltip")
	addLabelCommandsGrid(commandTranslationsHeaderGrid,"Shortcut")
	
	commandButtonsTab.init()
	enablePracticesTab.init()
	for command in commands:
		
		var label=addLabelCommandsGrid(commandTranslationsCommandsGrid,command)
		
		var tootipTextName=command+"_tooltip";
		label.mouse_filter=Control.MOUSE_FILTER_STOP

		GameEvents.register_allways_tooltip(label,tootipTextName)
# button translation
		var editBox = preload("res://EditCommandText.tscn").instance()
		editBox.commandName=command
		editBox.command=commandIndex
		
		var altText=Settings.commandTranslations[commandIndex];
		editBox.visible=true;
		
		commandTranslationsGrid.add_child(editBox)
		if altText!=null && altText!="":
			editBox.setText(altText)

# text translation
		editBox = preload("res://EditCommandText2.tscn").instance()
		editBox.commandName=command
		editBox.command=commandIndex
		
		altText=Settings.commandTextTranslations[commandIndex];
		editBox.visible=true;
		
		commandTranslationsGrid.add_child(editBox)
		if altText!=null && altText!="":
			editBox.setText(altText)

# tooltip		
		var editTooltipBox = preload("res://EditTooltipText.tscn").instance()
		editTooltipBox.commandName=command
		editTooltipBox.command=commandIndex
		
		var altTooltipText=Settings.tooltipTranslations[commandIndex];
		editTooltipBox.visible=true;
		
		commandTranslationsGrid.add_child(editTooltipBox)
		if altTooltipText!=null && altTooltipText!="":
			editTooltipBox.setText(altTooltipText)

# shortcut		
		var editShortcutBox = preload("res://EditShortcutText.tscn").instance()
		editShortcutBox.commandName=command
		editShortcutBox.command=commandIndex
		
		var altShortcutText=Settings.shortcutTranslations[commandIndex];
		editShortcutBox.visible=true;
		
		commandTranslationsGrid.add_child(editShortcutBox)
		if altShortcutText!=null && altShortcutText!="":
			editShortcutBox.setText(altShortcutText)
					
		commandIndex=commandIndex+1

	hideScrollBars()
	
	
	
func hasJavascript():
	return OS.has_feature('JavaScript')
	
func get_parameter(parameter):
	if hasJavascript():
		var value= JavaScript.eval("var url_string = window.location.href; var url = new URL(url_string); url.searchParams.get('"+parameter+"');")
		return value
	return null
			
				
func getSettings(removePrivate=false):
	var commandDict={}
	for i in range(0,Settings.commandTranslations.size()-1):
		var commandName=Constants.commandNames[i]
		var translation=Settings.commandTranslations[i]
		if translation!=null && translation!="":
			commandDict[commandName]=translation
	
	var commandTextDict={}
	for i in range(0,Settings.commandTextTranslations.size()-1):
		var commandName=Constants.commandNames[i]
		var translation=Settings.commandTextTranslations[i]
		if translation!=null && translation!="":
			commandTextDict[commandName]=translation
			
	var tooltipDict={}
	for i in range(0,Settings.tooltipTranslations.size()-1):
		var commandName=Constants.commandNames[i]
		var translation=Settings.tooltipTranslations[i]
		if translation!=null && translation!="":
			tooltipDict[commandName]=translation

	var shortcutDict={}
	for i in range(0,Settings.shortcutTranslations.size()-1):
		var commandName=Constants.commandNames[i]
		var translation=Settings.shortcutTranslations[i]
		if translation!=null && translation!="":
			shortcutDict[commandName]=translation
	
	var ruleset=rulesetManager.currentRulleset
	var save_dict = {"translations" : commandDict,
	  "customButtonSet":Settings.customButtonSet,
	  "ruleset":ruleset,
	  "highScore":Settings.highScore,
	  "zoom":Settings.zoom,
	  "language":Settings.currentLang,
	  "tooltips":tooltipDict,
	  "shortcuts":shortcutDict,
	  "textTranslations":commandTextDict,
	  "showCommandTooltips":Settings.showCommandTooltips,
	  "showShortCutsInButtons":Settings.showShortCutsInButtons,
	  "isScull":Settings.isScull,
	  "finishedPractices":Settings.finishedPractices,
	  "usePushAway": Settings.usePushAway,
	  "waterAnimation":Settings.waterAnimation,
	  "disabledPractices":Settings.disabledPractices,
	  "successCount":Settings.successCount
	}
	if removePrivate:
		removePrivateSettings(save_dict)
	return save_dict
	
func removePrivateSettings(settings):
	settings.erase("highScore")
	settings.erase("finishedPractices")
	settings.erase("waterAnimation")
	settings.erase("successCount")
	
func setSettings(dict,removePrivate=false,callSettingsChanged=true,alreadySetFromUrl=false):
	if removePrivate:
		removePrivateSettings(dict)
		
	if dict.has("highScore"):
		Settings.highScore=dict["highScore"]
	
	if dict.has("successCount"):
		Settings.successCount=dict["successCount"]
		
	var 	isScull=true
	if dict.has("isScull"): 
		 isScull=dict["isScull"]
	if Settings.isScull!=isScull:
		Settings.isScull=isScull
		
	isScullButton.set_pressed(isScull)
	
	if  dict.has("language"):
		Settings.currentLang=dict["language"]
		GameState.languageSetFromSettingsOrUl=true
	
	var finishedPractices=[]

	if dict.has("finishedPractices"):
	
		finishedPractices=dict["finishedPractices"]
	
		if typeof(finishedPractices)==TYPE_ARRAY:
			for i in finishedPractices.size():
				finishedPractices[i]=int(finishedPractices[i])
			# for testing
			#finishedPractices=[0,1,2,3,4,5,6,7,8,9,10]
			Settings.finishedPractices=finishedPractices
			
			
	if alreadySetFromUrl:
		return
	
	var translations={}
	if dict.has("translations"):
		translations=dict["translations"]
	
	var textTranslations={}
	if dict.has("textTranslations"):
		textTranslations=dict["textTranslations"]
		
	var tooltips={}
	if dict.has("tooltips"):
		tooltips=dict["tooltips"]

	var shortcuts={}
	if dict.has("shortcuts"):
		shortcuts=dict["shortcuts"]
	
	if dict.has("usePushAway"):
		Settings.usePushAway= dict["usePushAway"]
		
	var 	tooltipsOn=true
	if dict.has("showCommandTooltips"): 
		 tooltipsOn=dict["showCommandTooltips"]	
	Settings.showCommandTooltips=tooltipsOn
	showCommandTooltips.set_pressed(tooltipsOn)

	var 	shotCutsOn=false
	if dict.has("showShortCutsInButtons"): 
		 shotCutsOn=dict["showShortCutsInButtons"]
	Settings.showShortCutsInButtons=shotCutsOn
	showShortCutsInButtons.set_pressed(shotCutsOn)
	
	var customButtonSet=[]
	if dict.has("customButtonSet"):
		customButtonSet=dict["customButtonSet"]
	
	var 	waterAnimationOn=false
	if dict.has("waterAnimation"): 
		 waterAnimationOn=dict["waterAnimation"]
	Settings.waterAnimation=waterAnimationOn
	var waterAnimationButton=$TabContainer/DisplayTab/GridContainer/HBoxContainer2/WaterAnimationButton
	waterAnimationButton.set_pressed(waterAnimationOn)

	var disabledPractices=[]
	if dict.has("disabledPractices"):
		disabledPractices=dict["disabledPractices"]
		if typeof(finishedPractices)==TYPE_ARRAY:
			for i in disabledPractices.size():
				var practice=int(disabledPractices[i])
				disabledPractices[i]=practice
	
	if Settings.disabledPractices!=disabledPractices:
		Settings.disabledPractices=disabledPractices
		GameEvents.practicesChanged()
	#else:
	#	customButtonSet=GameState.defaultButtonSet
	
	
		
	
	if typeof(customButtonSet)==TYPE_ARRAY:
		Settings.customButtonSet=customButtonSet
		GameEvents.customButtonSetChanged()
	
	#clear translations and tooltips
	for i in range(0,commandTranslationsGrid.get_child_count()):
		var obj=commandTranslationsGrid.get_child(i);
		if obj.has_method("setText"): 
			commandTranslationsGrid.get_child(i).setText("")
		
	if translations!=null && typeof(translations)==TYPE_DICTIONARY:
		var keys=translations.keys();
	
		for translationName in keys:
			var iPos= Utilities.commandNameToCommand(translationName)
			
			if iPos>=0:
				var text=translations[translationName]
				Settings.commandTranslations[iPos]=text
				var iposChild=iPos*commandTranslationsGrid.columns;
				if iposChild<commandTranslationsGrid.get_child_count():
					commandTranslationsGrid.get_child(iposChild).setText(text)
	
	if textTranslations!=null && typeof(textTranslations)==TYPE_DICTIONARY:
		var keys=textTranslations.keys();
	
		for translationName in keys:
			var iPos= Utilities.commandNameToCommand(translationName)
			
			if iPos>=0:
				var text=textTranslations[translationName]
				Settings.commandTextTranslations[iPos]=text
				var iposChild=1+iPos*commandTranslationsGrid.columns;
				if iposChild<commandTranslationsGrid.get_child_count():
					commandTranslationsGrid.get_child(iposChild).setText(text)
					
	if tooltips!=null && typeof(tooltips)==TYPE_DICTIONARY:
		var keys=tooltips.keys();
	
		for translationName in keys:
			var iPos= Utilities.commandNameToCommand(translationName)
			
			if iPos>=0:
				var text=tooltips[translationName]
				Settings.tooltipTranslations[iPos]=text
				var iposChild=2+iPos*commandTranslationsGrid.columns;
				if iposChild<commandTranslationsGrid.get_child_count():
					commandTranslationsGrid.get_child(iposChild).setText(text)
	
	if shortcuts!=null && typeof(shortcuts)==TYPE_DICTIONARY:
		var keys=shortcuts.keys();
	
		for translationName in keys:
			var iPos= Utilities.commandNameToCommand(translationName)
			
			if iPos>=0:
				var text=shortcuts[translationName]
				Settings.shortcutTranslations[iPos]=text
				var iposChild=3+iPos*commandTranslationsGrid.columns;
				if iposChild<commandTranslationsGrid.get_child_count():
					commandTranslationsGrid.get_child(iposChild).setText(text)
				
	var ruleset=null
	if dict.has("ruleset"):
		ruleset=dict["ruleset"]
	else: 
		ruleset="RulesetDefault"
	
	if ruleset!=null:
		setRuleset(ruleset)
	
	var zoom = 2.1
	if dict.has("zoom"):
		zoom =dict["zoom"]
	
	if( zoom>0 && zoom<100) || zoom==-1:
		Settings.zoom=zoom;
	
	if callSettingsChanged:
		GameEvents.settingsChanged()
	
func saveSettings():
	var save_game = File.new()
	save_game.open(settingsFile, File.WRITE)
	var settings=getSettings()
	var json=to_json(settings)
	save_game.store_line(json)
	save_game.close()
	
func loadSettings():
	
	
	var settingFromUrl=false
	var settings=get_parameter("settings")
	if settings!=null && settings!="":
		var dict=parse_json(settings);
		if dict!=null:
			setSettings(dict,true,false)
			settingFromUrl=true
	

	var save_game = File.new()
	if  save_game.file_exists(settingsFile):
		save_game.open(settingsFile, File.READ)
		while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
			var dict2 = parse_json(save_game.get_line())
			#only load the high score here when set from the url
			# never call the setting changed
			setSettings(dict2,false,false,settingFromUrl)
		save_game.close()
	
	#override the lang with the url lang
	var urlLang=get_parameter("lang");
	if urlLang!=null:
		var urlLangIndex=Constants.urlKeys.find(urlLang)
		if urlLangIndex>=0:
			Settings.currentLang=Constants.languageKeys[urlLangIndex]
			GameState.languageSetFromSettingsOrUl=true

	GameEvents.settingsChanged()
	if settingFromUrl && hasJavascript():
		clearSettingsInUrl();
	
	loadResolution()
	
func _on_EditCommandText_customCommandTextChanged(command, commandName, value):
	if commandName==value:
		value=""
	Settings.commandTranslations[command]=value

func _on_EditCommandText_customCommandText2Changed(command, commandName, value):
	if commandName==value:
		value=""
	Settings.commandTextTranslations[command]=value

func _on_EditTooltipText_customTooltipTextChanged(command, commandName, value):
	Settings.tooltipTranslations[command]=value

func _on_EditTooltipText_customShortcutTextChanged(command, commandName, value):
	Settings.shortcutTranslations[command]=value
	
func _handleSettingsChanged():
	saveSettings()
	

func clearSettingsInUrl():
	JavaScript.eval("history.pushState({}, null, window.location.protocol + '//' + window.location.host + window.location.pathname)");


func ensureButtonsetSaved():
	commandButtonsTab.ensureButtonsetSaved()




func _on_ShowCommandTooltips_toggled(button_pressed):
	Settings.showCommandTooltips=button_pressed


func _on_ShowShortCutsInButtons_toggled(button_pressed):
	Settings.showShortCutsInButtons=button_pressed
	GameEvents.languageChanged()


func _on_Scull_toggled(button_pressed):
	Settings.isScull=button_pressed
	GameEvents.isScullChanged(Settings.isScull)
	if GameState.useDefaultButtonSet:
		GameState.currentButtonSet=GameState.getDefaultButtonSet()
	GameEvents.languageChanged()
	GameEvents.practicesChanged()

func _on_ResetPractices_pressed():
	$"%OptionStart".resetFinishedPractices()
	


func _on_UsePushAwayOption_item_selected(index):
	Settings.usePushAway= index;
	





func hideScrollBars():
	var commands=$TabContainer/CommandTranslateTab/ScrollContainerCommands
	var header=$TabContainer/CommandTranslateTab/ScrollContainerHeader
	commands.get_h_scrollbar().rect_scale.x = 0
	commands.get_v_scrollbar().rect_scale.y = 0
	header.get_h_scrollbar().rect_scale.x = 0
	header.get_v_scrollbar().rect_scale.y = 0
	

func _on_GridContainer_item_rect_changed():
	var commands=$TabContainer/CommandTranslateTab/ScrollContainerCommands
	var header=$TabContainer/CommandTranslateTab/ScrollContainerHeader
	var grid=$TabContainer/CommandTranslateTab/ScrollContainer
	header.scroll_horizontal=grid.scroll_horizontal
	commands.scroll_vertical=grid.scroll_vertical


func _on_GridContainerCommands_item_rect_changed():
	var commands=$TabContainer/CommandTranslateTab/ScrollContainerCommands
	var grid=$TabContainer/CommandTranslateTab/ScrollContainer
	grid.scroll_vertical=commands.scroll_vertical


func _on_GridContainerHeader_item_rect_changed():
	var header=$TabContainer/CommandTranslateTab/ScrollContainerHeader
	var grid=$TabContainer/CommandTranslateTab/ScrollContainer
	grid.scroll_horizontal=header.scroll_horizontal


func saveAndClose():
	GameEvents.settingsChanged()	
	visible=false
	GameEvents.startPlay()
	
func _on_CloseSettingsButton_pressed():
	saveAndClose()

func _on_ShareSettings_pressed():
	saveAndClose()
	$"%ShareSettingsDialog".start()


func _on_WaterAnimationButton_toggled(button_pressed):
	Settings.waterAnimation=button_pressed
	GameEvents.settingsChanged()


func loadResolution():
	var resolutionStr= JavaScript.eval("localStorage.getItem('resolution')");
	var resolution=0
	if resolutionStr=="Normal":
		resolution=1
	elif  resolutionStr=="High":
		resolution=2
	resolutionButton.selected=resolution

func _on_Resolution_item_selected(index):
	saveAndClose()
	var value=""
	if index==1:
		value="Normal"
	elif index==2:
		value="High"
	JavaScript.eval("localStorage.setItem('resolution','"+value+"');")
	JavaScript.eval("window.location.reload()")

