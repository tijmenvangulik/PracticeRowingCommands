extends OptionButton



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentLang=""


func _init():
	# get the default language from javascript
	var language=JavaScript.eval("navigator.language || navigator.userLanguage");
	if language==null || language.substr(0,2)=="nl":
		Settings.currentLang="nl_NL"
	else:
		Settings.currentLang="en"
	GameEvents.register_tooltip(self,"OptionLanguageTooltip")

	
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("settingsChangedSignal",self,"_settings_changedSignal")
	var i=0;
	for item in Constants.languageItems:
		var flagName=Constants.flags[i]
		var texture=load("res://assets/flags/"+flagName+".svg")
		add_icon_item(texture,item,i)
		i=i+1
	
	connect("item_selected",self,"selected")
	setLanguage(Settings.currentLang)	
	var styleDropDown= preload("res://MainDropDown.tres")
	var pm=get_popup()
	pm.add_stylebox_override("panel",styleDropDown)
	Utilities.styleDropDown(self)
	
func setLanguage(langKey):
	var indexNr=Constants.languageKeys.find(langKey)
	if indexNr>=0:
		TranslationServer.set_locale(langKey)
		select(indexNr)
		if currentLang!=langKey:
			currentLang=langKey
			Settings.currentLang=langKey
			GameEvents.languageChanged()
			

func selected(itemIndex : int):
	
	if itemIndex>=0:
		var langKey=Constants.languageKeys[itemIndex]		
		setLanguage(langKey)
		GameEvents.settingsChanged()

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _settings_changedSignal():
	if currentLang!=Settings.currentLang:
		setLanguage(Settings.currentLang)
