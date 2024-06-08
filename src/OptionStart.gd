extends OptionButton

export (NodePath) onready var boat = get_node(boat) as Boat

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
#do not change the order of these items
enum StartPos {
  StartTour,
  StilleggenOefenening,
  BochtOefenening,
  AchteruitvarenOefenening,
  AchteruitBochtOefenening
  Aanleggen,
  Aangelegd,
  StartStrijkendAanleggen,
  AanleggenWal,
  StartStrijkendAanleggenWal,
  StarGame,
  Start,
  Intro
}

var currentStartPos  = StartPos.Start
var stepDisabledTop=load("res://assets/stepDisabledTop.png")
var stepDisabledMid=load("res://assets/stepDisabledMid.png")
var stepDisabledBot=load("res://assets/stepDisabledBot.png")
var stepCheckTop=load("res://assets/stepCheckTop.png")
var stepCheckdMid=load("res://assets/stepCheckMid.png")
var stepCheckBot=load("res://assets/stepCheckBot.png")
var stepArrowTop=load("res://assets/stepArrowTop.png")
var stepArrowMid=load("res://assets/stepArrowMid.png")
var stepArrowBot=load("res://assets/stepArrowBot.png")

var stepDisabledIcons=[stepDisabledTop,stepDisabledMid,stepDisabledBot]
var stepCheckIcons=[stepCheckTop,stepCheckdMid,stepCheckBot]
var stepArrowIcons=[stepArrowTop,stepArrowMid,stepArrowBot]

var iconBoat=load("res://assets/iconBoat.png")
var infoIcon=load("res://assets/infoIcon.png")
var practiceIsActive = false;

func _ready():
#	add_icon_item(
	GameEvents.connect("crash",self,"_crashDetected")
	#add_item("StartPositie",StartPos.Start)
	add_item("StartTour",StartPos.StartTour)
	add_item("StartStilleggenOefenening",StartPos.StilleggenOefenening)
	add_item("StartBochtOefenening",StartPos.BochtOefenening)
	add_item("StartAchteruitvarenOefenening",StartPos.AchteruitvarenOefenening)
	
	add_item("StartAchteruitBochtOefenening",StartPos.AchteruitBochtOefenening)
	
	add_item("StartAanleggen",StartPos.Aanleggen)
	add_item("StartAangelegd",StartPos.Aangelegd)
	add_item("StartStrijkendAanleggen",StartPos.StartStrijkendAanleggen)

	add_item("StartAanleggenWal",StartPos.AanleggenWal)

	add_item("StartStrijkendAanleggenWal",StartPos.StartStrijkendAanleggenWal)
	add_item("StartStarGame",StartPos.StarGame)

	add_separator()
	add_item("StartOpWater",StartPos.Start)
	add_item("ShowIntroText",StartPos.Intro)
	
	setMenuIcons()
	connect("item_selected",self,"selected")
	text="StartPositie"
	icon=null;
	var pm=get_popup()
	pm.add_constant_override("vseparation",-1)
	# hide the radio
	for i in pm.get_item_count():
	        if pm.is_item_radio_checkable(i):
	            pm.set_item_as_radio_checkable(i, false)
    
	#improve style
	var styleDropDown= preload("res://MainDropDownPopup.tres")
	pm.add_stylebox_override("panel",styleDropDown)	
	pm.connect("id_pressed",self,"_menuItemClicked")
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_tooltip(self,"OptionStartTooltip")
	GameEvents.connect("settingsChangedSignal",self,"_handleSettingsChanged")
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")
	
func _menuItemClicked(itemId):
	doStart(itemId)

func _collectGameStateChangedSignal(state):
	if state==Constants.CollectGameState.Finished:
		savePractice()

func _introSignal(isVisible : bool):
	visible=!isVisible

func _handleSettingsChanged():
	setMenuIcons()
	
func practiceIsFinished(pos):
	return Settings.finishedPractices.find(pos)>=0
	
func setStoreFinishedPractice(pos):
	if (!practiceIsFinished(pos)):
		Settings.finishedPractices.append(pos)
		GameEvents.settingsChanged()

func startOnWater():
	doStart(StartPos.Start)
	
func setMenuIcons():
	var firstNotDone=-1;
	for i in get_item_count():
	   
		var itemId=get_item_id(i)
		var itemText=get_item_text(i)
		
		if itemText=="":
			itemId = -1
		if isPractice(itemId):
			var iconIndex=1
			if itemId==StartPos.StartTour:
				iconIndex=0
			if itemId==StartPos.StarGame:
				iconIndex=2
			if practiceIsFinished(itemId):				
				set_item_icon( i,stepCheckIcons[iconIndex])
			else:
				set_item_icon( i,stepDisabledIcons[iconIndex])
				if firstNotDone<0:
					firstNotDone=i
					set_item_icon( i,stepArrowIcons[iconIndex])
		if itemId==StartPos.Intro:
			set_item_icon(i,infoIcon)
		if itemId==StartPos.Start:
			set_item_icon(i,iconBoat)
	icon=null
	
func isPractice(pos):
	return pos>=0 && pos!=StartPos.Start && pos!=StartPos.Intro
  

func endPractice():
	if practiceIsActive:
		practiceIsActive=false
		savePractice()
		var t=boat.startTimer(2)
		yield(t, "timeout")
		boat.removeTimer(t)
		
		$"%EndPracticeDialog".show()

func _crashDetected():
	if practiceIsActive && currentStartPos!=StartPos.StarGame :
		practiceIsActive=false
		var t=boat.startTimer(2)
		yield(t, "timeout")
		boat.removeTimer(t)
		$"%EndCrashPracticeDialog".start()
		
func startPractices():
	currentStartPos=findNotFinishedPractice(StartPos.StartTour);
	# for now start the first practice
	doStart(currentStartPos)

func findNotFinishedPractice(startPos):
	 
	var i=getPracticeIndex(startPos)
	while ( i<get_item_count() && practiceIsFinished(startPos) && startPos!= StartPos.StarGame):
		i=i+1
		startPos=practiceIndexToStartPos(i);
	return startPos;
	
func savePractice():
	if isPractice( currentStartPos):
		setStoreFinishedPractice(currentStartPos)		
		setMenuIcons()	
		
func nextPractice():
	if isPractice( currentStartPos):
		currentStartPos=findNotFinishedPractice(currentStartPos)	
		doStart(currentStartPos)
		
func getPracticeIndex(startPos):
	for i in get_item_count():
		if get_item_id(i)==startPos:
			return i
	return 0
func practiceIndexToStartPos(i):
	if i<get_item_count():
		return self.get_item_id(i)
	else:
		return StartPos.StarGame

		
func restartPractice():
	doStart(currentStartPos)

func selected(itemIndex : int):	
	select(StartPos.Start)
	self.text="StartPositie"
	icon=null
	
func doStart(startItemId):
	if GameState.collectGameState!=Constants.CollectGameState.None:
		GameState.changeCollectGameState(Constants.CollectGameState.Stop)
	
	boat.resetCrashed()
	var Command=Constants.Command
	var isViking=GameState.isViking
	
	var explainPopup=$"%ExplainPracticeDialog"
	var callStartPlay=false
	Utilities.showOnlyButtons([])
	$"%PracticeCollectables".hideAll()
	var forwards=true
	currentStartPos=startItemId;
	if isPractice(currentStartPos):
		practiceIsActive=true
	match startItemId:
		StartPos.Start: 
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			callStartPlay=true
		StartPos.StilleggenOefenening:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt]	
			$"%CollectableStopBoatPractice".reset()
			explainPopup.showDialog("StopBoatPracticeExplainText",showOnlyButonsArray)
		StartPos.AchteruitvarenOefenening:
			forwards=false
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden]	
			$"%CollectableBackDownPractice".reset()
			explainPopup.showDialog("BackdownPracticeExplainText",showOnlyButonsArray)
		StartPos.BochtOefenening:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.HalenSB,Constants.Command.HalenBB,Constants.Command.HalenBeideBoorden,Constants.Command.VastroeienBB,Constants.Command.VastroeienSB]	
			$"%CollectableMakeTurnPractice".reset()
			explainPopup.showDialog("TurnPracticeExplainText",showOnlyButonsArray)
		StartPos.AchteruitBochtOefenening:
			forwards=false
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.StrijkenSB,Constants.Command.StrijkenBB]	
			$"%CollectableBackDownTurnPractice".reset()
			explainPopup.showDialog("BackdownTurnPracticeExplainText",showOnlyButonsArray)
		StartPos.Aanleggen:
			$"%CollectableMooringPractice".reset()			
			boat.setNewBoatPosition(702.307,2145.531,45,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienBB]	
			explainPopup.showDialog("MoringExplainRaftText",showOnlyButonsArray)
		StartPos.Aangelegd:
			$"%CollectableSailAwayPractice2".reset()			
			var showOnlyButonsArray=[]
			if isViking: 
				boat.setNewBoatPosition(1124,2596,0,Constants.StateOars.SlippenSB,true)
				showOnlyButonsArray =[Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.PeddelendStrijkenSB,Constants.Command.StrijkenBB,Constants.Command.HalenSB,Constants.Command.UitbrengenSB]	
			else:
				boat.setNewBoatPosition(1124,2608,0,Constants.StateOars.RiemenHoogSB,true)
				showOnlyButonsArray =[Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.HalenSB,Constants.Command.UitzettenSB]	
			explainPopup.showDialog("SailAwayExplainText",showOnlyButonsArray)
		StartPos.Intro: GameEvents.intro(true)
		StartPos.StartTour: GameEvents.startTour()
		StartPos.StartStrijkendAanleggen: 
			forwards=false
			$"%CollectableBackDownMooringPractice2".reset()			
			
			boat.setNewBoatPosition(1589.091,2426.734,-30,Constants.StateOars.Roeien,false)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienBB]	
			explainPopup.showDialog("BackwardsMoringRaftExplainText",showOnlyButonsArray)
		StartPos.AanleggenWal: 
			$"%CollectableMooringHighWallPractice".reset()
			
			boat.setNewBoatPosition(2082.239,2042.082,-45,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.SlippenSB,Constants.Command.VastroeienBB,Constants.Command.IntrekkenSB]	
			explainPopup.showDialog("MoringExplainText",showOnlyButonsArray)
		StartPos.StartStrijkendAanleggenWal: 
			forwards=false
			$"%CollectableBackDownMooringHighWallPractice".reset()
			
			boat.setNewBoatPosition(2220.23,1472.777,-120,Constants.StateOars.Roeien,false)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.SlippenSB,Constants.Command.VastroeienBB,Constants.Command.IntrekkenSB]	
			explainPopup.showDialog("BackwardsMoringExplainText",showOnlyButonsArray)
		StartPos.StarGame:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			GameState.changeCollectGameState(Constants.CollectGameState.ShowHighScores)
	
	if GameState.isForwards!=forwards:
		GameState.changeForwards(forwards)
	
	if callStartPlay: 
		GameEvents.startPlay()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
