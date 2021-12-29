extends Node



var collectedCount=0;
var gameStarted=false;
var time_elapsed=0.0
var lastSeconds=0
var lastMinutes=0
var lastTimeString=""
var crashedState=false;

func resetCrashed():
	crashedState=false;
	var boat=$"../Boat"
	boat.resetCrashed()
	
func _process(delta: float) -> void:
	if gameStarted:
		time_elapsed += delta	
		updateTime(false)
		var boat=$"../Boat"
		if boat.crashState && !crashedState:
			crashedState=true;
			gameFinished()
	
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
		var c=getCounterControl()
		lastTimeString=formatTime(minutes,seconds,miliSeconds)
		c.updateTime(lastTimeString)
		lastSeconds=seconds
		lastMinutes=minutes
	
func _ready():
	hideAll()

func collect(amount : int):
	setCollected(collectedCount+amount)
	if collectedCount==self.get_child_count():		
		gameFinished()

func getCounterControl():
	return $"/root/World/CanvasLayer/RightTopButtons/CollectedCount"	
	
func setCollected(amount):
	collectedCount=amount
	var c=getCounterControl();
	c.setCount(collectedCount,self.get_child_count())
	
func reset():	
	for c in get_children():
		c.reset()
	time_elapsed=0.0
	
func hideAll():
	for c in self.get_children():
		c.hide()

func updateHighScoreControl(highScore):
	var counter=getCounterControl()
	var highScoreText=formatScore(highScore,true)
	counter.setHighScore(highScoreText)
	
func startGame(crashed):
	var highScore= getHighScore()
	if highScore>0:
		updateHighScoreControl(highScore)
	var dlg=$"../CanvasLayer/StartCollectGame"
	dlg.init()
	dlg.show_modal(true)
	
func doStartGame():
	
	resetCrashed()
	reset()
	setCollected(0)
	var c=getCounterControl();
	c.visible=true;
	gameStarted=true

func stopGame():
	var c=getCounterControl();
	c.visible=false;
	hideAll()
	resetCrashed()
	
func gameFinished():
	gameStarted=false
	var crashed=crashedState
	resetCrashed()
	var boat=$"/root/World/Boat"
	
	updateTime(true)
	
	var t=boat.startTimer(1)
	yield(t, "timeout")
	boat.removeTimer(t)

	boat.setNewBoatPosition(984.05,1995.76,0,boat.StateOars.Roeien,true)
	
	t=boat.startTimer(1.1)
	yield(t, "timeout")
	boat.removeTimer(t)

	stopGame()
	var isHighScore=false
	
	var bestTime=getHighScore()
	if !crashed && (bestTime<=0 || time_elapsed<bestTime):
		setHighScore(time_elapsed)
		isHighScore=true	
	
	var dlg=$"../CanvasLayer/EndCollectGame";
	if crashed:
		dlg.initCrashed()
	else:
		dlg.init(lastTimeString,isHighScore)
	
	dlg.show_modal(true)

func getHighScore():
	var config=$"../CanvasLayer/SettingsDialog"
	return config.highScore
	
func setHighScore(score):
	var config=$"../CanvasLayer/SettingsDialog"
	config.highScore=score;
	config.saveSettings()
	updateHighScoreControl(score);
	

