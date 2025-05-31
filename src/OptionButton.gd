extends OptionButton



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentLang=""

var editIcon=load("res://assets/editIconLong.png")


func _init():
	# get the default language from javascript
	var language=JavaScript.eval("navigator.language || navigator.userLanguage");
	if language==null || language.substr(0,2)=="nl":
		Settings.currentLang="nl_NL"
	else:
		Settings.currentLang="en"
	GameEvents.register_tooltip(self,"OptionLanguageTooltip")
	

func addLanguageItem(i):
	var flagName=Languages.flags[i]
	var texture=load("res://assets/flags/"+flagName+".svg")		
	add_icon_item(texture,Languages.languageLongItems[i],i)

func addCustomLanguageItem(i):
	var flagName=Languages.flags[i]
	var newTexture=Utilities.getColoredBlade(GameState.sharedSettingsBladeColor,flagName)
	add_icon_item(newTexture,Languages.languageLongItems[i],i)
	
func addModifyIcon():
	add_icon_item(editIcon,"ModifyLanguages",-2)
	var pm=get_popup()
	pm.set_item_as_radio_checkable(pm.get_item_count()-1, false)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("settingsChangedSignal",self,"_settings_changedSignal")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.connect("loadedSharedSettings",self,"_loadedSharedSettings");
	
	for i in Languages.languageLongItems.size():
		addLanguageItem(i)
	addModifyIcon()
	
	connect("item_selected",self,"selected")
	setLanguage(Settings.currentLang)	
	
	setStyle(Settings.highContrast)
	Utilities.styleDropDown(self)

func _loadedSharedSettings():
	loadedSharedSettings()
	setLanguage(Languages.sharedSettingLangKey)

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

func recalcFromBaseSettingSwitch():
	$"%SettingsDialog".recalcIsScullFromSettings()

func loadedSharedSettings():
	var index=BaseSettings.loadedSharedSettings()
	if index>=0:
		# remove the edit icon		
		var itemId=get_item_id(get_item_count()-1)
		if itemId==-2:
			remove_item(get_item_count()-1)
		# when there is an custom item rmove it
		if get_item_id(get_item_count()-1)==index:
			remove_item(index)
		addCustomLanguageItem(Languages.languageKeys.size()-1)
		addModifyIcon()
		
func setLanguage(langKey):
	var  customSet=false
	var recalc=false;
	var indexNr=Languages.languageKeys.find(langKey)
	if indexNr>=0:
		var realLang=langKey
		var baseSettings=Languages.baseConfigs[indexNr]
		if langKey==Languages.sharedSettingLangKey:
			BaseSettings.activateSharedSetting()
			realLang=BaseSettings.language
			customSet=true
			recalc=true
		elif baseSettings!="":
			BaseSettings.loadBaseSetings(baseSettings)
			realLang=BaseSettings.language
#			var customItemIndex=Languages.languageKeys.find(Languages.sharedSettingLangKey)
#			if customItemIndex>=0:
#				set_item_text(customItemIndex,BaseSettings.settingsName)
			customSet=true
			recalc=true
		else:
			if BaseSettings.active:
				BaseSettings.clearBaseSettings()
				recalc=true
	
		TranslationServer.set_locale(realLang)
		select(indexNr)
	
		Settings.currentLang=langKey
		GameEvents.languageChanged()
#			var langDefaultSettings=tr("SettingsOverride")
#			if langDefaultSettings!="" && currentLang!="nl_NL":
#				var settings = parse_json(langDefaultSettings)
#				$"%SettingsDialog".setSettings(settings,true)
	if recalc:
		recalcFromBaseSettingSwitch()
	text=""

func selected(itemIndex : int):
	var itemId=get_item_id(itemIndex)
	if itemId>=0 :
		var langKey=Languages.languageKeys[itemId]		
		setLanguage(langKey)
		GameEvents.settingsChanged()
	else:
		$"%SettingsDialog".start(2)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _settings_changedSignal():
	if currentLang!=Settings.currentLang:
		setLanguage(Settings.currentLang)
