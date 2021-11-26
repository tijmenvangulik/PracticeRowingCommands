extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var commandTranslations = [""]

func addLabel(container,text):
	var new_label = Label.new()
	new_label.text=text
	new_label.add_font_override("font",load("res://Font.tres"))
	container.add_child(new_label)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	
	var boat=$"../../Boat"
	var commands=boat.commandNames
	while commandTranslations.size()<commands.size():
		commandTranslations.push_back("")
	
	# wait till all readies are called	
	yield(get_tree(), "idle_frame")
	
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
	var save_dict = {"translations" : commandDict,
	  "customButtonSet":customButtonSet}
	return save_dict
	
func setSettings(dict):
	var translations= dict["translations"]
	var boat=$"../../Boat"
	var customButtonSet=dict["customButtonSet"]
	if typeof(customButtonSet)==TYPE_ARRAY && customButtonSet.size()>0:
		var buttonSetManger=$"TabContainer/CommandButtonsTab";
		buttonSetManger.customButtonSet=customButtonSet
		$"../ButtonsContainer".setButtonSet(customButtonSet)
	if translations!=null && typeof(translations)==TYPE_DICTIONARY:
		var keys=translations.keys();
		for translationName in keys:
			var iPos= boat.commandNameToCommand(translationName)
			if iPos>=0:
				commandTranslations[iPos]=translations[translationName]
	
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
