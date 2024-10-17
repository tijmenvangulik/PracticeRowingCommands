extends Node


var commandTranslations = [""]
var tooltipTranslations = [""]
var commandTextTranslations = [""]
var shortcutTranslations = [""]
var highScore=0.0
var currentLang="nl_NL"
var zoom=-1
var customButtonSet=[]
var showCommandTooltips=false
var showShortCutsInButtons=false
var isScull =true;
var finishedPractices=[]
var usePushAway = Constants.DefaultYesNo.Default;
var waterAnimation = false
var disabledPractices=[]


func usePushAwayActive():
	if  Settings.usePushAway == Constants.DefaultYesNo.Default:
		var val=tr("UsePushAway")
		return val=="TRUE"
	return Settings.usePushAway  == Constants.DefaultYesNo.Yes;
