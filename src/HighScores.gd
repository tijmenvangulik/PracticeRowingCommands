extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var goToEndGameOnContine=false

export (NodePath) onready var grid = get_node(grid) as GridContainer
export (NodePath) onready var gridQuarter = get_node(gridQuarter) as GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_onHighScoresRequest")
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")
	loadHighScores()

func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");
	GameEvents.connect("windowSizeChanged",self,"_sizeChanged");

func setWidth():
	margin_right=0
	
func _sizeChanged():
	setWidth()
	
func loadHighScores():
	var url=Constants.serverUrl+"/gameHighScores?data[game]=1&data[level]=0&data[secondary]=quarter"
	$HTTPRequest.request(url, [], true, HTTPClient.METHOD_GET)

func setMyHighScore():
	var highScoreText=tr("HighScoreNone")
	if Settings.highScore>0:
		highScoreText=Utilities.formatScore(Settings.highScore,true)	
	$"OwnHighScoreValue".text=highScoreText
	
func start():
	setMyHighScore()
	show_modal(true)
	loadHighScores()
	$ContinueToStartGame.grab_focus()
	
func stop():
	visible=false


func _onHighScoresRequest(result, response_code, headers, body):
		var text=body.get_string_from_utf8()
		if response_code==200:
			var json = JSON.parse(text)
			var scores=json.result.scores
			GameState.publicHighscores=[]
			for score in scores:
				GameState.publicHighscores.append({"name":score.name,"score":score.score/1000.0,"level":score.level})
				
		refreshScoreGrid()

func clearGrid(g):
	for N in g.get_children():
		g.remove_child(N)
		N.free()

func refreshScoreGrid():	
	clearGrid(grid)
	clearGrid(gridQuarter)
	
	for score in GameState.publicHighscores:
		var addGrid=grid;
		if score.level>0:
			addGrid=gridQuarter
		var i=addGrid.get_child_count()/addGrid.columns
		addLabel(addGrid,str(1+addGrid.get_child_count()/3)+")")
		addLabel(addGrid,Utilities.formatScore(score.score,true))
		addLabel(addGrid,score.name)
	
func _collectGameStateChangedSignal(state):
	if state==Constants.CollectGameState.ShowHighScores:
		start()
	else:
		if visible: 
			stop()
			start()
			
	
func addLabel(container,text):
	var new_label = Label.new()
	new_label.text=text
	new_label.add_font_override("font",load("res://Font.tres"))
	container.add_child(new_label)
	return new_label


func _on_ContinueToStartGame_pressed():
	visible=false
	if goToEndGameOnContine:
		goToEndGameOnContine=false
		$"../EndCollectGame".show_modal(true)
	else:
		GameState.changeCollectGameState(Constants.CollectGameState.Start)
