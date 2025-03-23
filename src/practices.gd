extends Node

# keep in same order as practiceNames
var practices = [
Constants.StartItem.StartTour,
Constants.StartItem.StilleggenOefenening,
Constants.StartItem.BochtOefenening,
Constants.StartItem.AchteruitvarenOefenening,
Constants.StartItem.AchteruitBochtOefenening,
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
	if !Settings.isScull && startItem==Constants.StartItem.SlalomPractice:
		return false
	return  practiceIsEnabled(startItem) 

func practiceIsEnabled(startItem :int):
	if Settings.disabledPracticesUseDefault:
		return  Practices.languageDisabledPractices.find(startItem)<0 
	return  Settings.disabledPractices.find(startItem)<0 

func getPracticeName(startItem :int):
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
	var disabledPractices=tr("DisabledPractices")
	if disabledPractices!=null && disabledPractices!="DisabledPractices" && disabledPractices!="":		
		var p= JSON.parse(disabledPractices)
		if typeof(p.result)==TYPE_ARRAY:
			for i in p.result.size():
				p.result[i]=int(p.result[i])
			if languageDisabledPractices!=p.result:
				languageDisabledPractices=p.result
				GameEvents.practicesChanged()

func _languageChangedSignal():
	Practices.loadLanguageDisabledPractices()

func getPracticeTranslation(startPos:int)->String:
	if startPos>=0 && startPos<Settings.practiceTranslations.size():
		return Settings.practiceTranslations[startPos]
	return ""

func getPracticeExplainText(startPos:int):
	var result=getPracticeExplainTranslation(startPos)
	if result=="" && startPos<Constants.practiceExplainTexts.size():
		result=Constants.practiceExplainTexts[startPos]
	return result
	
func getPracticeExplainTranslation(startPos:int)->String:
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
