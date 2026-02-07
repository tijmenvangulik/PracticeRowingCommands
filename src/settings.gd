extends Node


var commandTranslations = [""]
var tooltipTranslations = [""]
var commandTextTranslations = [""]
var shortcutTranslations = [""]
var highScore=0.0
var currentLang="nl_NL"
var zoom=-1
var customButtonSet=[]
var customButtonSetMobile=[]
var showCommandTooltips=true
var showShortCutsInButtons=false
var boatType = Constants.BoatType.Default;
var finishedPractices=[]
var waterAnimation = false
var disabledPractices=[]
var disabledPracticesUseDefault = true
var successCount =0 
var highContrast=false
var practiceTranslations= [""]
var practiceExplainTranslations= [""]
var sharedSettings : Dictionary
var checkFrameRateDisabled = false
var highScoreName=""
var highScoreClub=""
var speakCommands = Constants.SpeakCommandsType.Default;
var speechCultureCode=""
