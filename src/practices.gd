extends Node

var practices = [
Constants.StartItem.StartTour,
Constants.StartItem.StilleggenOefenening,
Constants.StartItem.BochtOefenening,
Constants.StartItem.AchteruitvarenOefenening,
Constants.StartItem.AchteruitBochtOefenening,
Constants.StartItem.Aanleggen,
Constants.StartItem.Aangelegd,
Constants.StartItem.StartStrijkendAanleggen,
Constants.StartItem.AanleggenWal,
Constants.StartItem.StartStrijkendAanleggenWal,
Constants.StartItem.MoringHarbour,
Constants.StartItem.StarGame
]

var practiceNames = [
"StartTour",
"StartStilleggenOefenening",
"StartBochtOefenening",
"StartAchteruitvarenOefenening",
"StartAchteruitBochtOefenening",
"StartAanleggen",
"StartAangelegd",
"StartStrijkendAanleggen",
"StartAanleggenWal",
"StartStrijkendAanleggenWal",
"StartMoringHarbour",
"StartStarGame"
]

func _ready():
		GameEvents.connect("languageChangedSignal",self,"_languageChangedSignal");
		
var languageDisabledPractices=[]

func practiceIsVisible(startItem :int):
	return  practiceIsEnabled(startItem) && practiceIsLanguageEnabled(startItem)

func practiceIsEnabled(startItem :int):
	return  Settings.disabledPractices.find(startItem)<0 

func practiceIsLanguageEnabled(startItem :int):
	return  Practices.languageDisabledPractices.find(startItem)<0 


func getPracticeName(startItem :int):
	var ind=practices.find(startItem)
	if ind>=0:
		return practiceNames[ind]
	return ""
	
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
	