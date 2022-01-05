extends OptionButton


var currentLang="nl_NL"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var languageItems=["Nederlands viking","Nederlands","English"]
var languageKeys=["nl_NL","nl","en"]
var isViking=true

func _init():
	# get the default language from javascript
	var language=JavaScript.eval("navigator.language || navigator.userLanguage");
	if language==null || language.substr(0,2)=="nl":
		currentLang="nl_NL"
	else:
		currentLang="en"

# Called when the node enters the scene tree for the first time.
func _ready():
	var i=0;
	for item in languageItems:		
		add_item(item,i)
		i=i+1
	
	connect("item_selected",self,"selected")

	setLanguage(currentLang)	
	
func setLanguage(langKey):
	var indexNr=languageKeys.find(langKey)
	if indexNr>=0:
		TranslationServer.set_locale(langKey)
		select(indexNr)
		$"../../ButtonsContainer".initButtons()
		currentLang=langKey

func selected(itemIndex : int):
	
	if itemIndex>=0:
		var langKey=languageKeys[itemIndex]
		isViking= langKey=="nl_NL"
		setLanguage(langKey)
		$"../../SettingsDialog".saveSettings()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
