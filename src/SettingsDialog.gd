extends WindowDialog

class_name SettingsDialog
#RuleSets
export (NodePath) onready var rulesetManager = get_node(rulesetManager) as RuleSets
export (NodePath) onready var ruleSetDropDown = get_node(ruleSetDropDown) as OptionButton
export (NodePath) onready var commandTranslationsGrid = get_node(commandTranslationsGrid) as GridContainer

export (NodePath) onready var commandButtonsTab = get_node(commandButtonsTab) as CommandButtonsTab

var settingsFile="user://settings.save"

func addLabel(container,text):
	var new_label = Label.new()
	new_label.text=text
	new_label.add_font_override("font",load("res://Font.tres"))
	container.add_child(new_label)

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
	GameEvents.connect("settingsChangedSignal",self,"_handleSettingsChanged")

	get_close_button().hide()
	
	var commands=Constants.commandNames
	while Settings.commandTranslations.size()<commands.size():
		Settings.commandTranslations.push_back("")
	
	# wait till all readies are called	
	yield(get_tree(), "idle_frame")
	
	loadRulesets();
	
	loadSettings()

	
	#https://www.tilcode.com/godot-3-centering-a-grid-of-evenly-spaced-buttons-on-screen/
	#https://docs.godotengine.org/en/stable/getting_started/step_by_step/ui_game_user_interface.html
	var commandIndex=0;
	addLabel(commandTranslationsGrid,"Commando")
	addLabel(commandTranslationsGrid,"Alternative text")
	commandButtonsTab.init()
	for command in commands:
		
		addLabel(commandTranslationsGrid,command)		
		var editBox = preload("res://EditCommandText.tscn").instance()
		editBox.commandName=command
		editBox.command=commandIndex
		
		var altText=Settings.commandTranslations[commandIndex];
		editBox.visible=true;
		
		commandTranslationsGrid.add_child(editBox)
		if altText!=null && altText!="":
			editBox.setText(altText)
		commandIndex=commandIndex+1
	
func getSettings():
	var commandDict={}
	for i in range(0,Settings.commandTranslations.size()-1):
		var commandName=Constants.commandNames[i]
		var translation=Settings.commandTranslations[i]
		if translation!=null && translation!="":
			commandDict[commandName]=translation
	var ruleset=rulesetManager.currentRulleset
	var save_dict = {"translations" : commandDict,
	  "customButtonSet":Settings.customButtonSet,
	  "ruleset":ruleset,
	  "highScore":Settings.highScore,
	  "zoom":Settings.zoom,
	  "language":Settings.currentLang
	}
	return save_dict
	
func setSettings(dict):
	var translations=null
	if dict.has("translations"):
		translations=dict["translations"]
		
	var customButtonSet=null
	if dict.has("customButtonSet"):
		customButtonSet=dict["customButtonSet"]
	if typeof(customButtonSet)==TYPE_ARRAY && customButtonSet.size()>0:
		Settings.customButtonSet=customButtonSet
		GameEvents.customButtonSetChanged()
		
	if translations!=null && typeof(translations)==TYPE_DICTIONARY:
		var keys=translations.keys();
	
		for translationName in keys:
			var iPos= Utilities.commandNameToCommand(translationName)
			
			if iPos>=0:				
				var text=translations[translationName]
				Settings.commandTranslations[iPos]=text
				var iposChild=3+iPos*2;
				if iposChild<commandTranslationsGrid.get_child_count():
					commandTranslationsGrid.get_child(iposChild).setText(text)
				
	var ruleset=null
	if dict.has("ruleset"):
		ruleset=dict["ruleset"]
	if ruleset!=null:
		setRuleset(ruleset)
	if dict.has("highScore"):
		Settings.highScore=dict["highScore"]
	if dict.has("zoom"):
		var zoom =dict["zoom"]
		if zoom>0 && zoom<100:
			Settings.zoom=zoom;
	if  dict.has("language"):
		Settings.currentLang=dict["language"]
	
	GameEvents.settingsChanged()
	
func saveSettings():
	var save_game = File.new()
	save_game.open(settingsFile, File.WRITE)
	var settings=getSettings()
	save_game.store_line(to_json(settings))
	save_game.close()
	
func loadSettings():
	var save_game = File.new()
	if not save_game.file_exists(settingsFile):
		return # Error! We don't have a save to load.
	save_game.open(settingsFile, File.READ)
	while save_game.get_position() < save_game.get_len():
        # Get the saved dictionary from the next line in the save file
		var dict = parse_json(save_game.get_line())
		setSettings(dict)
	save_game.close()

func _on_EditCommandText_customCommandTextChanged(command, commandName, value):
	Settings.commandTranslations[command]=value

func _handleSettingsChanged():
	saveSettings()

func ensureButtonsetSaved():
	commandButtonsTab.ensureButtonsetSaved()
