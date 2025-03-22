extends OptionButton

export (NodePath) onready var boat = get_node(boat) as Boat

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
#do not change the order of these items

var currentStartPos  = Constants.StartItem.Start
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

var practicePoints = 0

var sendStartOnWaterMessage= false

var replacedPushAwayButtons = false

func loadItems():
	clear()
	for startItem in Practices.practices:
		if Practices.practiceIsVisible(startItem):
			var title=Practices.getTranslatedPracticeName(startItem)
			add_item(title,startItem)
	add_separator()
	add_item("StartOpWater",Constants.StartItem.Start)
	add_item("ShowIntroText",Constants.StartItem.Intro)
	
	var pm=get_popup()
	pm.add_constant_override("vseparation",-1)
	# hide the radio
	for i in pm.get_item_count():
	        if pm.is_item_radio_checkable(i):
	            pm.set_item_as_radio_checkable(i, false)

	setIcons()
	text="StartPositie"
	icon=null;
	
func _ready():
#	add_icon_item(
	GameEvents.connect("crash",self,"_crashDetected")
	#add_item("StartPositie",Constants.StartItem.Start)
	
	loadItems()
	connect("item_selected",self,"selected")
	
	#improve style
	setStyle()
	var pm=get_popup()
	pm.connect("id_pressed",self,"_menuItemClicked")
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_tooltip(self,"OptionStartTooltip")
	GameEvents.connect("settingsChangedSignal",self,"_handleSettingsChanged")
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")
	GameEvents.connect("practicesChanged",self,"_practicesChanged");
	GameEvents.connect("doCommandSignal",self,"_doCommandSignal")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")

func setStyle():	
	var pm=get_popup()
	Styles.SetPopupPanelDropDownStyle(pm)

func _highContrastChangedSignal(highContrast):
	setStyle()
	
func _menuItemClicked(itemId):
	$"%Recorder".cancelReplay()
	doStart(itemId)

func _collectGameStateChangedSignal(state):
	if state==Constants.CollectGameState.Finished:
		savePractice()
		logEndPractice(true)
	if state==Constants.CollectGameState.Crashed:
		logEndPractice(false)
	
func _introSignal(isVisible : bool):
	visible=!isVisible

func _practicesChanged():
	loadItems()
	
func _doCommandSignal(command:int):
	if sendStartOnWaterMessage:
		#for start on water log on first stroke
		sendStartOnWaterMessage=false
		logEndPractice(true)

func _handleSettingsChanged():
	setIcons()
	
func practiceIsFinished(pos):
	return Settings.finishedPractices.find(pos)>=0
	
func setStoreFinishedPractice(pos):
	if (!practiceIsFinished(pos)):
		Settings.finishedPractices.append(pos)
		GameEvents.settingsChanged()

func resetFinishedPractices():
	Settings.finishedPractices=[]
	GameEvents.settingsChanged()
	setIcons()	
	
func startOnWater():
	doStart(Constants.StartItem.Start)
	
func setStarStyle(startPos ,style): 
	for c in $"%PracticeCollectables".get_children():
		if c.practiceStartPosNr==startPos:
			c.setIconStyle(style)

func setIcons():
	practicePoints=0
	var nrOfPractices=0
	var firstNotDone=-1;
	for i in get_item_count():
	   
		var itemId=get_item_id(i)
		var itemText=get_item_text(i)
		
		if itemText=="":
			itemId = -1
		if isPractice(itemId):		
			if itemId!=Constants.StartItem.StartTour: 
				nrOfPractices=nrOfPractices+1
			var iconIndex=1
			if itemId==Constants.StartItem.StartTour:
				iconIndex=0
			if itemId==Constants.StartItem.StarGame:
				iconIndex=2
			if practiceIsFinished(itemId):
				if itemId!=Constants.StartItem.StartTour: 
					practicePoints=practicePoints+1
				set_item_icon( i,stepCheckIcons[iconIndex])
				setStarStyle(itemId,Constants.CollectableSpriteStyle.PracticeCollected)
			else:
				setStarStyle(itemId,Constants.CollectableSpriteStyle.Practice)
				set_item_icon( i,stepDisabledIcons[iconIndex])
				if firstNotDone<0:
					firstNotDone=i
					set_item_icon( i,stepArrowIcons[iconIndex])
		if itemId==Constants.StartItem.Intro:
			set_item_icon(i,infoIcon)
		if itemId==Constants.StartItem.Start:
			set_item_icon(i,iconBoat)
	icon=null
	$"%PracticeCounter".setCount( practicePoints, nrOfPractices)
	
func isPractice(pos):
	return pos>=0 && pos!=Constants.StartItem.Start && pos!=Constants.StartItem.Intro

func endPractice():

	var recorder=$"%Recorder"
	
	
	if practiceIsActive:
		practiceIsActive=false
		if !GameState.isReplaying:
			var earnedStar=!practiceIsFinished(currentStartPos)
			
			savePractice()
			var t=Utilities.startTimer(2)
			yield(t, "timeout")
			Utilities.removeTimer(t)

			if  recorder.isRecording:
				recorder.stopRecording()
			else:
				logEndPractice(true)
				var askFeedback=false
				Settings.successCount+=1
				GameEvents.settingsChanged()
				
				if Settings.successCount==3:
					$"%EndPracticeFeedbackDialog".start(earnedStar)
				else:
					$"%EndPracticeDialog".start(earnedStar)
		
func logEndPractice(success : bool):
	var currentName= Constants.StartItem.keys()[currentStartPos] ;
	if ( !OS.is_debug_build() ):
		$"%LogActivityRequest".logFinishedActivity(currentName,success,Settings.isScull)

func _crashDetected():
	var extraWaitTime=0;
	if practiceIsActive && currentStartPos==Constants.StartItem.SlalomPractice  && boat.stateOars== Constants.StateOars.Roeien:
		var text=tr("DoNotForgetToMoveOarsOutOfTheWay")
		text=Utilities.replaceCommandsInText(text,false)
		extraWaitTime=4;
		boat.showError(text,6)
		
	if practiceIsActive && currentStartPos!=Constants.StartItem.StarGame :
		practiceIsActive=false
		var t=Utilities.startTimer(2+extraWaitTime)
		yield(t, "timeout")
		Utilities.removeTimer(t)
		$"%EndCrashPracticeDialog".start()
		logEndPractice(false)

func startPractices():
	currentStartPos=findNotFinishedPractice(Constants.StartItem.StartTour);
	#wait a bit so the events can be handles first
	var t=Utilities.startTimer(0.1)
	yield(t, "timeout")
	Utilities.removeTimer(t)
	# for now start the first practice
	doStart(currentStartPos)

func findNotFinishedPractice(startItem):
	 
	var i=getPracticeIndex(startItem)
	while ( i<get_item_count() && practiceIsFinished(startItem) && startItem!= Constants.StartItem.StarGame):
		i=i+1
		startItem=practiceIndexToStartPos(i);
	return startItem
	
func savePractice():
	if isPractice( currentStartPos):
		setStoreFinishedPractice(currentStartPos)		
		setIcons()	
		
func nextPractice():
	if isPractice( currentStartPos):
		currentStartPos=findNotFinishedPractice(currentStartPos)	
		doStart(currentStartPos)
		
func skipPractice():
	if isPractice( currentStartPos):
		var i=getPracticeIndex(currentStartPos)+1
		if i<get_item_count() :
			currentStartPos=practiceIndexToStartPos(i);
			doStart(currentStartPos)
		
func getPracticeIndex(startItem):
	for i in get_item_count():
		if get_item_id(i)==startItem:
			return i
	return 0
	
func practiceIndexToStartPos(i):
	if i<get_item_count():
		return self.get_item_id(i)
	else:
		return Constants.StartItem.StarGame

		
func restartPractice():
	doStart(currentStartPos)

func selected(itemIndex : int):	
	select(Constants.StartItem.Start)
	self.text="StartPositie"
	icon=null


func doStart(startItemId):
	if GameState.collectGameState!=Constants.CollectGameState.None:
		GameState.changeCollectGameState(Constants.CollectGameState.Stop)
	
	if startItemId==Constants.StartItem.Start:
		sendStartOnWaterMessage=true
	else:
		sendStartOnWaterMessage=false

	boat.resetCrashed()
	var Command=Constants.Command
	
	var explainPopup=$"%ExplainPracticeDialog"
	var callStartPlay=false
	Utilities.showOnlyButtons([])
	$"%PracticeCollectables".hideAll()
	$"%SlalomPracticeItems".changeVisible(false)
	var forwards=true
	currentStartPos=startItemId;
	if isPractice(currentStartPos):
		practiceIsActive=true

	if replacedPushAwayButtons:
		$"%ButtonsContainer".loadButtons(Constants.DefaultYesNo.Default)
		replacedPushAwayButtons=false

	match startItemId:
		Constants.StartItem.Start: 
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			callStartPlay=true
		Constants.StartItem.StilleggenOefenening:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt]	
			$"%CollectableStopBoatPractice".reset()
			explainPopup.showDialog("StopBoatPracticeExplainText",showOnlyButonsArray)
		Constants.StartItem.AchteruitvarenOefenening:
			forwards=false
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,false)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden]	
			$"%CollectableBackDownPractice".reset()
			explainPopup.showDialog("BackdownPracticeExplainText",showOnlyButonsArray)
		Constants.StartItem.BochtOefenening:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.HalenSB,Constants.Command.HalenBB,Constants.Command.HalenBeideBoorden,Constants.Command.VastroeienBB,Constants.Command.VastroeienSB]	
			$"%CollectableMakeTurnPractice".reset()
			explainPopup.showDialog("TurnPracticeExplainText",showOnlyButonsArray)
		Constants.StartItem.AchteruitBochtOefenening:
			forwards=false
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,false)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.StrijkenSB,Constants.Command.StrijkenBB]	
			$"%CollectableBackDownTurnPractice".reset()
			explainPopup.showDialog("BackdownTurnPracticeExplainText",showOnlyButonsArray)
		Constants.StartItem.Aanleggen:
			boat.setNewBoatPosition(702.307,2145.531,45,Constants.StateOars.Roeien,true)
			$"%CollectableMooringPractice".reset()			
			var showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienBB]	
			explainPopup.showDialog("MoringExplainRaftText",showOnlyButonsArray)
		Constants.StartItem.Aangelegd:
			$"%ButtonsContainer".loadButtons(Constants.DefaultYesNo.No)
			replacedPushAwayButtons=true
			boat.setNewBoatPosition(1124,2596,0,Constants.StateOars.SlippenSB,true)
			var showOnlyButonsArray  =[Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.PeddelendStrijkenSB,Constants.Command.StrijkenBB,Constants.Command.HalenSB,Constants.Command.UitbrengenSB]	
			$"%CollectableSailAwayPractice2".reset()			
			explainPopup.showDialog("SailAwayExplainText",showOnlyButonsArray)
		Constants.StartItem.AangelegdUitzetten:
			$"%ButtonsContainer".loadButtons(Constants.DefaultYesNo.Yes)
			replacedPushAwayButtons=true
			boat.setNewBoatPosition(1124,2608,0,Constants.StateOars.RiemenHoogSB,true)
			var showOnlyButonsArray =[Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.HalenSB,Constants.Command.UitzettenSB,Constants.Command.VastroeienBeideBoorden,Constants.Command.UitbrengenSB]
			$"%CollectableSailAwayPractice3".reset()
			explainPopup.showDialog("SailAwayExplainPushAwayText",showOnlyButonsArray)
		Constants.StartItem.Intro:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)		
			$"%IntroDialog".start()
		Constants.StartItem.StartTour: GameEvents.startTour()
		Constants.StartItem.StartStrijkendAanleggen: 
			forwards=false
			
			boat.setNewBoatPosition(1589.091,2426.734,-30,Constants.StateOars.Roeien,false)
			$"%CollectableBackDownMooringPractice2".reset()			
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienBB]	
			explainPopup.showDialog("BackwardsMoringRaftExplainText",showOnlyButonsArray)
		Constants.StartItem.AanleggenWal: 
			boat.setNewBoatPosition(2082.239,2042.082,-45,Constants.StateOars.Roeien,true)
			$"%CollectableMooringHighWallPractice".reset()
			var showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.SlippenSB,Constants.Command.VastroeienBB,Constants.Command.IntrekkenSB]	
			explainPopup.showDialog("MoringExplainText",showOnlyButonsArray)
		Constants.StartItem.StartStrijkendAanleggenWal: 
			forwards=false
			
			boat.setNewBoatPosition(2220.23,1472.777,-120,Constants.StateOars.Roeien,false)
			$"%CollectableBackDownMooringHighWallPractice".reset()
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.SlippenSB,Constants.Command.VastroeienBB,Constants.Command.IntrekkenSB]	
			explainPopup.showDialog("BackwardsMoringExplainText",showOnlyButonsArray)
		Constants.StartItem.StarGame:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			GameState.changeCollectGameState(Constants.CollectGameState.ShowHighScores)
		Constants.StartItem.MoringHarbour: 
			
			boat.setNewBoatPosition(241,1219,90,Constants.StateOars.Roeien,true)
			$"%CollectableMooringHarbourPractice".reset()
			$"%CollectableMooringHarbourPractice2".reset()
			$"%CollectableMooringHarbourPractice3".reset()
			var showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienSB,Constants.Command.HalenBB,Constants.Command.HalenSB,Constants.Command.StrijkenBeidenBoorden,Constants.Command.StrijkenBB,Constants.Command.StrijkenSB,Constants.Command.HalenBeideBoorden,Constants.Command.VastroeienBB,Constants.Command.VastroeienBeideBoorden]	
			explainPopup.showDialog("MoringHarbourExplainText",showOnlyButonsArray)
		Constants.StartItem.SlalomPractice: 
			boat.setNewBoatPosition(945,2160,0,Constants.StateOars.Roeien,true)
			$"%SlalomPracticeItems".changeVisible(true)
			$"%CollectableSlalomPractice".reset()
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.VastroeienSB,Constants.Command.HalenBB,Constants.Command.HalenSB,Constants.Command.StrijkenBeidenBoorden,Constants.Command.StrijkenBB,Constants.Command.StrijkenSB,Constants.Command.HalenBeideBoorden,Constants.Command.VastroeienBB,Constants.Command.VastroeienBeideBoorden,Constants.Command.SlippenBB,Constants.Command.Slippen,Constants.Command.SlippenSB,Constants.Command.UitbrengenBB,Constants.Command.Uitbrengen,Constants.Command.UitbrengenSB,Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt]
			explainPopup.showDialog("StartSlalomPracticeExplainText",showOnlyButonsArray)
		Constants.StartItem.BridgePractice: 
			boat.setNewBoatPosition(1915,110,270,Constants.StateOars.Roeien,true)
			$"%CollectableBridgePractice".reset()
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.SlagklaarAf,Constants.Command.Slippen,Constants.Command.Uitbrengen,Constants.Command.PakMaarWeerOp]	
			explainPopup.showDialog("BridgeExplainText",showOnlyButonsArray)
			
	if GameState.isForwards!=forwards:
		GameState.changeForwards(forwards)
	
	if callStartPlay: 
		GameEvents.startPlay()

