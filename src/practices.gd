extends Node

# keep in same order as practiceNames
var practices = [
Constants.StartItem.StartTour,
Constants.StartItem.StilleggenOefenening,
Constants.StartItem.BochtOefenening,
Constants.StartItem.AchteruitvarenOefenening,
Constants.StartItem.AchteruitBochtOefenening,
Constants.StartItem.SpinTurnPractice,
Constants.StartItem.Aanleggen,
Constants.StartItem.AanleggenWal,
Constants.StartItem.AangelegdUitzetten,
Constants.StartItem.Aangelegd,
Constants.StartItem.StartStrijkendAanleggen,
Constants.StartItem.StartStrijkendAanleggenWal,
Constants.StartItem.BridgePractice,
Constants.StartItem.MoringHarbour,
Constants.StartItem.SlalomPractice,
Constants.StartItem.StarGame,
]

# keep in same order as practices
var practiceNames = [
"StartTour",
"StartStilleggenOefenening",
"StartBochtOefenening",
"StartAchteruitvarenOefenening",
"StartAchteruitBochtOefenening",
"StartSpinTurnPractice",
"StartAanleggen",
"StartAanleggenWal",
"StartAangelegdUitzetten",
"StartAangelegd",
"StartStrijkendAanleggen",
"StartStrijkendAanleggenWal",
"StartBridgePractice",
"StartMoringHarbour",
"StartSlalomPractice",
"StartStarGame"
]

func _ready():
	GameEvents.connect("languageChangedSignal",self,"_languageChangedSignal");
		
var languageDisabledPractices=[]

func practiceIsVisible(startItem :int):
	if !GameState.isScull && startItem==Constants.StartItem.SlalomPractice:
		return false
	return  practiceIsEnabled(startItem) 

func practiceIsEnabled(startItem :int):
	if Settings.disabledPracticesUseDefault:
		return  Practices.languageDisabledPractices.find(startItem)<0 
	return  Settings.disabledPractices.find(startItem)<0 

func getPracticeName(startItem :int):
	var result=Utilities.getDefaultArrayValueSetting("PracticeTranslations",startItem)
	if result!="":
		return result
	var ind=practices.find(startItem)
	if ind>=0:
		return practiceNames[ind]
	return ""
	
func getTranslatedPracticeName(startItem : int):
	var title=getPracticeTranslation(startItem)
	if title=="":
		title=getPracticeName(startItem)
	return title
	
func loadLanguageDisabledPractices():
	var disabledPractices=Utilities.getDefaultJsonSetting("DisabledPractices")
	if disabledPractices!=null:
		if typeof(disabledPractices)==TYPE_ARRAY:
			for i in disabledPractices.size():
				disabledPractices[i]=int(disabledPractices[i])
			if languageDisabledPractices!=disabledPractices:
				languageDisabledPractices=disabledPractices
				GameEvents.practicesChanged()

func _languageChangedSignal():
	Practices.loadLanguageDisabledPractices()

func getPracticeTranslation(startPos:int,useDefaultSettings=true)->String:
	var result=""
	if useDefaultSettings:
		result=Utilities.getDefaultArrayValueSetting("PracticeTranslations",startPos)
	if result!="":
		return result
	if startPos>=0 && startPos<Settings.practiceTranslations.size():
		return Settings.practiceTranslations[startPos]
	return ""

func getPracticeExplainText(startPos:int,useDefaultSettings =true):
	var result=getPracticeExplainTranslation(startPos,useDefaultSettings)
	if result=="" && startPos<Constants.practiceExplainTexts.size():
		result=Constants.practiceExplainTexts[startPos]
	return result
	
func getPracticeExplainTranslation(startPos:int,useDefaultSettings =true)->String:
	var result=""
	if useDefaultSettings:
		result=Utilities.getDefaultArrayValueSetting("PracticeExplainTranslations",startPos)
	if result!="":
		return result
	if startPos>=0 && startPos<Settings.practiceExplainTranslations.size():
		return Settings.practiceExplainTranslations[startPos]
	return ""

func setPracticeTranslation(startPos:int,title : String):	
	Settings.practiceTranslations=calcSetPracticeTranslation(Settings.practiceTranslations,startPos,title)

func setPracticeExplainTranslation(startPos:int,text : String):	
	Settings.practiceExplainTranslations=calcSetPracticeExplainTranslation(Settings.practiceExplainTranslations,startPos,text)

func calcArraySetUpdate(items ,startPos:int,value : String):
	if value!="":
		while startPos>=items.size():
			items.append("")
	if startPos<items.size():
		items[startPos]=value
	return items

func calcSetPracticeTranslation(practiceTranslations ,startPos:int,title : String):
	return calcArraySetUpdate(practiceTranslations,startPos,title)
	
func calcSetPracticeExplainTranslation(practiceEplainTranslations ,startPos:int,text : String):
	return calcArraySetUpdate(practiceEplainTranslations,startPos,text)
