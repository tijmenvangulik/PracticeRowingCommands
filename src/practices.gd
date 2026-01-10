extends Node

# keep in same order as practiceNames
var practices = [
Constants.StartItem.StartTour, #0
Constants.StartItem.StilleggenOefenening, #1
Constants.StartItem.BochtOefenening, #2
Constants.StartItem.AchteruitvarenOefenening, #3
Constants.StartItem.AchteruitBochtOefenening, #4
Constants.StartItem.SpinTurnPractice, #5
Constants.StartItem.Aanleggen, #6
Constants.StartItem.AanleggenBB, #7
Constants.StartItem.AanleggenWal, #8
Constants.StartItem.AangelegdUitzetten, #9
Constants.StartItem.AangelegdUitzettenBB, #10
Constants.StartItem.Aangelegd, #11
Constants.StartItem.AangelegdBB,
Constants.StartItem.StartStrijkendAanleggen, #12
Constants.StartItem.StartStrijkendAanleggenWal, #13
Constants.StartItem.BridgePractice, #14
Constants.StartItem.MoringHarbour, #15
Constants.StartItem.MoringHarbourBB, #16
Constants.StartItem.SlalomPractice,  #17
Constants.StartItem.StarGame #18
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
"StartAanleggenBB",
"StartAanleggenWal",
"StartAangelegdUitzetten",
"StartAangelegdUitzettenBB",
"StartAangelegd",
"StartAangelegdBB",
"StartStrijkendAanleggen",
"StartStrijkendAanleggenWal",
"StartBridgePractice",
"StartMoringHarbour",
"StartMoringHarbourBB",
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
