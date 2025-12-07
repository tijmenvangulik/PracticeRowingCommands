extends Node

class_name Collectables

export (NodePath) onready var collectedCounter = get_node(collectedCounter) as CollectedCounter
export (NodePath) onready var boat = get_node(boat) as Boat

var collectedCount=0;
var gameStarted=false;
var time_elapsed=0.0
var lastSeconds=0
var lastMinutes=0
var lastTimeString=""
var crashedState=false;
var startPlayTime=0
var updateDelta: float=0.0
var last_time_elapsed=0.0

func testEndGame():
#	time_elapsed=393044 #230.10
	time_elapsed=60*5+60+0.100 #230.10
	startPlayTime=getTime()-time_elapsed
	GameState.changeCollectGameState(Constants.CollectGameState.Finish)
	gameFinish()
	
func resetCrashed():
	crashedState=false;
	boat.resetCrashed()

func getTime():
	return OS.get_ticks_msec()/1000.0
		
func _process(delta: float) -> void:
	if gameStarted:
		updateDelta=updateDelta+delta
		#do not update the time every frame
		#there is a sys call to get the time involved
		if updateDelta>0.2:
			updateDelta=0.0			
			updateTime(false)
			if time_elapsed<=last_time_elapsed:
				crashedState=true
				gameFinish()
			last_time_elapsed=time_elapsed
			
			
		if boat.crashState && !crashedState:
			crashedState=true;
			GameState.changeCollectGameState(Constants.CollectGameState.Finish)

		
func updateTime(includeMiliSeconds):	
	time_elapsed = getTime()-startPlayTime
	var timeParts=Utilities.extractTimeParts(time_elapsed,includeMiliSeconds)
	var minutes = timeParts[0]
	var seconds =  timeParts[1]
	var miliSeconds=timeParts[2]

	if includeMiliSeconds || lastSeconds!=seconds || lastMinutes!=minutes:
		
		lastTimeString=Utilities.formatTime(minutes,seconds,miliSeconds)
		collectedCounter.updateTime(lastTimeString)
		lastSeconds=seconds
		lastMinutes=minutes
	
func _ready():
	hideAll()
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")

func collect(amount : int):
	setCollected(collectedCount+amount)
	if collectedCount==self.get_child_count():		
		GameState.changeCollectGameState(Constants.CollectGameState.Finish)

	
func setCollected(amount):
	collectedCount=amount

	collectedCounter.setCount(collectedCount,self.get_child_count())
	
func reset():	
	for c in get_children():
		c.reset()
	time_elapsed=0.0
	updateDelta=0.0
	last_time_elapsed=0.0
	startPlayTime = getTime()
	
func hideAll():
	for c in self.get_children():
		c.hide()

func updateHighScoreControl(highScore):
	var highScoreText=Utilities.formatScore(highScore,true)
	collectedCounter.setHighScore(highScoreText)
	
func startGame():
	var highScore= getHighScore()
	if highScore>0:
		updateHighScoreControl(highScore)
	
func doStartGame():
	
	resetCrashed()
	reset()
	setCollected(0)

	collectedCounter.visible=true;
	$"%PracticeCounter".visible=false;
	gameStarted=true

func stopGame():
	collectedCounter.visible=false;
	$"%PracticeCounter".visible=true;
	hideAll()
	resetCrashed()
	gameStarted=false
	GameState.changeCollectGameState(Constants.CollectGameState.None)
	
func gameFinish():
	if !gameStarted:
		return
	gameStarted=false
	var crashed=crashedState
	
	updateTime(true)
	
	var t=Utilities.startTimer(1)
	yield(t, "timeout")
	Utilities.removeTimer(t)
	resetCrashed()

	boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
	
	t=Utilities.startTimer(1.1)
	yield(t, "timeout")
	Utilities.removeTimer(t)

	stopGame()
	var isHighScore=false
	
	var bestTime=getHighScore()
	if !crashed && (bestTime<=0 || time_elapsed<bestTime):
		setHighScore(time_elapsed)
		isHighScore=true	
	
	if crashed:
		GameState.changeCollectGameState(Constants.CollectGameState.Crashed)
	else:
		GameState.game_time_elapsed=time_elapsed
		GameState.collectGameLastTimeString =lastTimeString
		GameState.collectGameIsHighScore=isHighScore
		
		GameState.changeCollectGameState(Constants.CollectGameState.Finished)
	
func getHighScore():
	return Settings.highScore
	
func setHighScore(score):
	Settings.highScore=score;
	GameEvents.settingsChanged()
	updateHighScoreControl(score);
	
func _collectGameStateChangedSignal(state):
	if state==Constants.CollectGameState.DoStart:
		doStartGame()
	elif state==Constants.CollectGameState.Start:
		startGame()
	elif state==Constants.CollectGameState.Stop:
		stopGame()
	elif state==Constants.CollectGameState.Finish:
		gameFinish()

