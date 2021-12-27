extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var commandTranslations = [""]
var highScore=0.0

func addLabel(container,text):
	var new_label = Label.new()
	new_label.text=text
	new_label.add_font_override("font",load("res://Font.tres"))
	container.add_child(new_label)

func loadRulesets():
	var ruleSets=$"/root/World/Boat/Rulesets".getRulesets()
	var rulesetControl=$"TabContainer/GeneralSettingsTab/GridContainer/RuleSetDropDown"
	var i=0
	for ruleSet in ruleSets:
		rulesetControl.add_item(ruleSet,i)
		i=i+1

func _on_RuleSetDropDown_item_selected(index):
	var ruleSetsNode=$"/root/World/Boat/Rulesets"
	var ruleSets=ruleSetsNode.getRulesets()
	var ruleSet=ruleSets[index];
	ruleSetsNode.setRuleset(ruleSet)
	saveSettings()

func setRuleset(ruleset):
	var ruleSetsNode=$"/root/World/Boat/Rulesets"
	var ruleSets=ruleSetsNode.getRulesets()
	ruleSetsNode.setRuleset(ruleset)
	var rulesetControl=$"TabContainer/GeneralSettingsTab/GridContainer/RuleSetDropDown"
	var index=ruleSets.find(ruleset)
	if index>=0:
		rulesetControl.select(index)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	
	var boat=$"../../Boat"
	var commands=boat.commandNames
	while commandTranslations.size()<commands.size():
		commandTranslations.push_back("")
	
	# wait till all readies are called	
	yield(get_tree(), "idle_frame")
	
	loadRulesets();
	
	loadSettings()

	var container=$"TabContainer/CommandTranslateTab/ScrollContainer/GridContainer"
	
	#https://www.tilcode.com/godot-3-centering-a-grid-of-evenly-spaced-buttons-on-screen/
	#https://docs.godotengine.org/en/stable/getting_started/step_by_step/ui_game_user_interface.html
	var commandIndex=0;
	addLabel(container,"Commando")
	addLabel(container,"Alternative text")
	$"TabContainer/CommandButtonsTab".init()
	for command in commands:
		
		addLabel(container,command)		
		var editBox = preload("res://EditCommandText.tscn").instance()
		editBox.commandName=command
		editBox.command=commandIndex
		
		var altText=commandTranslations[commandIndex];
		editBox.visible=true;
		
		container.add_child(editBox)
		if altText!=null && altText!="":
			editBox.setText(altText)
		commandIndex=commandIndex+1
	
func getSettings():
	var commandDict={}
	var boat=$"../../Boat"
	for i in range(0,commandTranslations.size()-1):
		var commandName=boat.commandNames[i]
		var translation=commandTranslations[i]
		if translation!=null && translation!="":
			commandDict[commandName]=translation
	var customButtonSet=$"TabContainer/CommandButtonsTab".customButtonSet
	var ruleset=$"/root/World/Boat/Rulesets".currentRulleset
	var zoom=$"/root/World/Boat/Camera2D2".zoom.x
	var save_dict = {"translations" : commandDict,
	  "customButtonSet":customButtonSet,
	  "ruleset":ruleset,
	  "highScore":highScore,
	  "zoom":zoom}
	return save_dict
	
func setSettings(dict):
	var translations=null
	if dict.has("translations"):
		translations=dict["translations"]
	var boat=$"../../Boat"
	var customButtonSet=null
	if dict.has("customButtonSet"):
		customButtonSet=dict["customButtonSet"]
	if typeof(customButtonSet)==TYPE_ARRAY && customButtonSet.size()>0:
		var buttonSetManger=$"TabContainer/CommandButtonsTab";
		buttonSetManger.customButtonSet=customButtonSet
		$"../ButtonsContainer".setCustomButtonSet(customButtonSet)
	if translations!=null && typeof(translations)==TYPE_DICTIONARY:
		var keys=translations.keys();
		var commandTranslationsGrid=$"TabContainer/CommandTranslateTab/ScrollContainer/GridContainer"
	
		for translationName in keys:
			var iPos= boat.commandNameToCommand(translationName)
			
			if iPos>=0:				
				var text=translations[translationName]
				commandTranslations[iPos]=text
				var iposChild=3+iPos*2;
				if iposChild<commandTranslationsGrid.get_child_count():
					commandTranslationsGrid.get_child(iposChild).setText(text)
				
	var ruleset=null
	if dict.has("ruleset"):
		ruleset=dict["ruleset"]
	if ruleset!=null:
		setRuleset(ruleset)
	if dict.has("highScore"):
		highScore=dict["highScore"]
	if dict.has("zoom"):
		var zoom=dict["zoom"]
		if zoom>0 && zoom<100:
			$"/root/World/Boat/Camera2D2".zoom.x=zoom
			$"/root/World/Boat/Camera2D2".zoom.y=zoom
			$"/root/World/Boat".setForwardsPosition(0)
	
func saveSettings():
	var save_game = File.new()
	save_game.open("user://settings.save", File.WRITE)
	var settings=getSettings()
	save_game.store_line(to_json(settings))
	save_game.close()
	
func loadSettings():
	var save_game = File.new()
	if not save_game.file_exists("user://settings.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://settings.save", File.READ)
	while save_game.get_position() < save_game.get_len():
        # Get the saved dictionary from the next line in the save file
		var dict = parse_json(save_game.get_line())
		setSettings(dict)
	save_game.close()

func _on_EditCommandText_customCommandTextChanged(command, commandName, value):
	commandTranslations[command]=value


