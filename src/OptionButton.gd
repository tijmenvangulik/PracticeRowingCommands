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
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	GameEvents.connect("introSignal",self,"_introSignal")
	var i=0;
	for item in Constants.languageLongItems:
		var flagName=Constants.flags[i]
		var texture=load("res://assets/flags/"+flagName+".svg")
		
		add_icon_item(texture,item,i)
		i=i+1
	
	connect("item_selected",self,"selected")
	setLanguage(Settings.currentLang)	
	
	setStyle(Settings.highContrast)
	Utilities.styleDropDown(self)
	
func setStyle(highContrast):
	var pm=get_popup()
	if highContrast:
		pm.add_stylebox_override("panel",Styles.styleMainDropDownHighContrast)
	else:
		pm.add_stylebox_override("panel",Styles.styleMainDropDown)

func _introSignal(isVisible):
	if isVisible:
		setStyle(true)
	else:
		setStyle(Settings.highContrast)

func _highContrastChangedSignal(highContrast):
	setStyle(Settings.highContrast)
	
func setLanguage(langKey):
	var indexNr=Constants.languageKeys.find(langKey)
	if indexNr>=0:
		TranslationServer.set_locale(langKey)
		select(indexNr)
		if currentLang!=langKey:
			currentLang=langKey
			Settings.currentLang=langKey
			GameEvents.languageChanged()
#			var langDefaultSettings=tr("SettingsOverride")
#			if langDefaultSettings!="" && currentLang!="nl_NL":
#				var settings = parse_json(langDefaultSettings)
#				$"%SettingsDialog".setSettings(settings,true)
				
	text=""

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
