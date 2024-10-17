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

func testEndGame():
	time_elapsed=230.10
	GameState.changeCollectGameState(Constants.CollectGameState.Finish)
	gameFinish()
	
func resetCrashed():
	crashedState=false;
	boat.resetCrashed()
	
func _process(delta: float) -> void:
	if gameStarted:
		time_elapsed += delta	
		updateTime(false)
		if boat.crashState && !crashedState:
			crashedState=true;
			GameState.changeCollectGameState(Constants.CollectGameState.Finish)

		
func updateTime(includeMiliSeconds):
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
	
func highScorePosition(newScore):
	var result=false
	var i=1
	for score in GameState.publicHighscores:
		if newScore<score.score:
			return i
		i=i+1
	if i<5: 
		return i
	return 0
	
func gameFinish():
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
		GameState.collectGameLastTimeString =lastTimeString
		GameState.collectGameIsHighScore=isHighScore
		if isHighScore:
			GameState.publicHighScorePositon=highScorePosition(time_elapsed)
		else: 
			GameState.publicHighScorePositon=0
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

