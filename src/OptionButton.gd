extends OptionButton



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var languageItems=["Nederlands viking","Nederlands","English"]
var languageKeys=["nl_NL","nl","en"]
var currentLang=""


func _init():
	# get the default language from javascript
	var language=JavaScript.eval("navigator.language || navigator.userLanguage");
	if language==null || language.substr(0,2)=="nl":
		Settings.currentLang="nl_NL"
	else:
		Settings.currentLang="en"

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("settingsChangedSignal",self,"_settings_changedSignal")
	var i=0;
	for item in languageItems:		
		add_item(item,i)
		i=i+1
	
	connect("item_selected",self,"selected")

	setLanguage(Settings.currentLang)	
	var styleDropDown= preload("res://MainDropDown.tres")
	get_popup().add_stylebox_override("panel",styleDropDown)

func setLanguage(langKey):
	var indexNr=languageKeys.find(langKey)
	if indexNr>=0:
		TranslationServer.set_locale(langKey)
		GameState.isViking= langKey=="nl_NL"
		select(indexNr)
		if currentLang!=langKey:
			currentLang=langKey
			Settings.currentLang=langKey
			GameEvents.languageChanged()
			

func selected(itemIndex : int):
	
	if itemIndex>=0:
		var langKey=languageKeys[itemIndex]		
		setLanguage(langKey)
		GameEvents.settingsChanged()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _settings_changedSignal():
	if currentLang!=Settings.currentLang:
		setLanguage(Settings.currentLang)
