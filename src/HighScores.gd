extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var goToEndGameOnContine=false

export (NodePath) onready var grid = get_node(grid) as GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_onHighScoresRequest")
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")
	get_close_button().hide()
	loadHighScores()

func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");

func loadHighScores():
	var url="https://ergometer-space.org/manager/gameHighScores?data[game]=1&data[level]=0"
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
	
func stop():
	visible=false


func _onHighScoresRequest(result, response_code, headers, body):
		var text=body.get_string_from_utf8()
		if response_code==200:
			var json = JSON.parse(text)
			var scores=json.result.scores
			GameState.publicHighscores=[]
			for score in scores:
				GameState.publicHighscores.append({"name":score.name,"score":score.score/1000.0})
				
		refreshScoreGrid()
	
func refreshScoreGrid():
	for N in grid.get_children():
		grid.remove_child(N)
		N.free()
	var i=1
	for score in GameState.publicHighscores:
		addLabel(grid,str(i)+")")
		addLabel(grid,Utilities.formatScore(score.score,true))
		addLabel(grid,score.name)
		i=i+1
func _collectGameStateChangedSignal(state):
	if state==Constants.CollectGameState.ShowHighScores:
		start()
	else:
		if visible: 
			stop()
			
	
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
