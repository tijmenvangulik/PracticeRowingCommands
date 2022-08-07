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

	
func formatTime(minutes,seconds,miliSeconds):
	var minStr=String(minutes)
	if minStr.length()==1:
		minStr="0"+minStr
	var secStr=String(seconds)
	if secStr.length()==1:
		secStr="0"+secStr
	var miliSecStr=""
	if miliSeconds>=0:
		miliSecStr="."+String(miliSeconds)
	return minStr+":"+secStr+miliSecStr

func extractTimeParts(time,includeMiliSeconds):
	var seconds = int( fmod(time, 60))
	var minutes = int( time / 60)
	var miliSeconds=-1
	if includeMiliSeconds:
		miliSeconds=int(fmod(time_elapsed*1000,1000))
	return [minutes,seconds,miliSeconds]
	
func formatScore(time,includeMiliSeconds):
	var timeParts=extractTimeParts(time,includeMiliSeconds)
	var minutes = timeParts[0]
	var seconds =  timeParts[1]
	var miliSeconds=timeParts[2]
	return formatTime(minutes,seconds,miliSeconds)
		
func updateTime(includeMiliSeconds):
	var timeParts=extractTimeParts(time_elapsed,includeMiliSeconds)
	var minutes = timeParts[0]
	var seconds =  timeParts[1]
	var miliSeconds=timeParts[2]

	if includeMiliSeconds || lastSeconds!=seconds || lastMinutes!=minutes:
		
		lastTimeString=formatTime(minutes,seconds,miliSeconds)
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
	var highScoreText=formatScore(highScore,true)
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
	gameStarted=true

func stopGame():
	collectedCounter.visible=false;
	hideAll()
	resetCrashed()
	gameStarted=false
	GameState.changeCollectGameState(Constants.CollectGameState.None)
	
func gameFinish():
	gameStarted=false
	var crashed=crashedState
	
	updateTime(true)
	
	var t=boat.startTimer(1)
	yield(t, "timeout")
	boat.removeTimer(t)
	resetCrashed()

	boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
	
	t=boat.startTimer(1.1)
	yield(t, "timeout")
	boat.removeTimer(t)

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
