extends OptionButton



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var languageItems=["NL viking","Nederlands","English"]
var languageKeys=["nl_NL","nl","en"]
var urlKeys=["nl_viking","nl","en"]
var flags=["nl","nl","gb"]

var currentLang=""


func _init():
	# get the default language from javascript
	var language=JavaScript.eval("navigator.language || navigator.userLanguage");
	if language==null || language.substr(0,2)=="nl":
		Settings.currentLang="nl_NL"
	else:
		Settings.currentLang="en"
	GameEvents.register_tooltip(self,"OptionLanguageTooltip")

func initFromUrl():
	var urlLang =JavaScript.eval("window.location.search");
	
	if urlLang!=null && urlLang.begins_with("?lang="):
		urlLang=urlLang.replace("?lang=","")
		var urlLangIndex=urlKeys.find(urlLang)
		if urlLangIndex>=0:
			Settings.currentLang=languageKeys[urlLangIndex]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("settingsChangedSignal",self,"_settings_changedSignal")
	var i=0;
	for item in languageItems:
		var flagName=flags[i]
		var texture=load("res://assets/flags/"+flagName+".svg")
		add_icon_item(texture,item,i)
		i=i+1
	
	connect("item_selected",self,"selected")
	initFromUrl()
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
		var urlLang=urlKeys[itemIndex]
		JavaScript.eval("history.pushState({}, null, window.location.protocol + '//' + window.location.host + window.location.pathname + '?lang="+urlLang+"')");

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _settings_changedSignal():
	if currentLang!=Settings.currentLang:
		setLanguage(Settings.currentLang)
