extends Node

var isForwards=true

var collectGameState= Constants.CollectGameState.None

var collectGameLastTimeString =""
var collectGameIsHighScore=false
var publicHighScorePositon=0
var publicHighscores = []

var defaultButtonSet=["SlagklaarAf","LaatLopen,Bedankt","VastroeienSB","HalenSB","StrijkenSB","StrijkenBeidenBoorden","VastroeienBeideBoorden","VastroeienBB","HalenBB","StrijkenBB","Slippen","SlippenSB","UitbrengenSB","UitzettenSB","RondmakenSB","Uitbrengen","SlippenBB","UitbrengenBB","UitzettenBB","RondmakenBB","HalenBeideBoorden","LightPaddle","LightPaddleBedankt","RiemenHoogBB","RiemenHoogSB"]
var currentButtonSet=defaultButtonSet
var useDefaultButtonSet=true;

var dialogIsOpen = false;

var isReplaying = false
var backgroundReplay = false

var languageSetFromSettingsOrUl = false

var isScull = true

var sharedSettingsBladeColorDefault=Color("#ffffff")
var sharedSettingsBladeColor=sharedSettingsBladeColorDefault

var mobileMode = false

var enabledCommands=[]
var isHighRes=true

func checkIsMobileMode():
	#for debug mobile enable
	#if OS.is_debug_build():
	#	return true
	if OS.has_feature('JavaScript'):
		var result=JavaScript.eval("isMobileMode()")
		return result==true;
	return GameState.mobileMode
	
func _ready():
	GameState.mobileMode=checkIsMobileMode()
	if mobileMode:
		var font= preload("res://Font.tres")
		font.size=24
	
func changeCollectGameState(newState):
	if collectGameState!=newState:
		collectGameState=newState
		GameEvents.collectGameStateChanged(newState)

var showTooltips= false

func changeForwards(newForwards):
	isForwards=newForwards;
	GameEvents.forwardBackwardsChanged()

func getDefaultButtonSet():
	if GameState.isScull:
		return defaultButtonSet
	# translate to not scull
	var result :Array=[]
	for item in GameState.defaultButtonSet:
		var sumItems=item.split(",");
		var subResult=[]
		for subItem in sumItems:
			if subItem== "SlippenSB":
				subResult.append("IntrekkenSB")
			elif subItem== "SlippenBB":
				subResult.append("IntrekkenBB")
			elif subItem!="Slippen" && subItem!="Uitbrengen":
				subResult.append(subItem)
		if subResult.size()>0:
			result.append(",".join(subResult))
		else:
			result.append("")
	return result

func recalcIsScull():
	var boatType=Settings.boatType;
	if boatType==Constants.BoatType.Default:
		var langBoatType=Utilities.getDefaultSetting("DefaultBoatType")
		if langBoatType=="Sweep": 
			boatType=Constants.BoatType.Sweep
		else:
			boatType=Constants.BoatType.Scull
		
	isScull=boatType!=Constants.BoatType.Sweep
