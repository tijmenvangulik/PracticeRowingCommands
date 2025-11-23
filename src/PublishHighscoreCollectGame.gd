extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _nameTextBox
var _clubTextBox

var testScore= false
# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	$HTTPRequest.connect("request_completed", self, "_onUploadRequest")
	get_close_button().hide()
	_nameTextBox=$"NameContainer/Name"
	_clubTextBox=$RowingClubContainer/RowingClub
	
func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");
	
func statEndGameDialog():
	visible=false
	$"../EndCollectGame".show_modal(true)

func start():
	readScoreNames()
	
	$"NameRequiredError".visible=false;
	if GameState.publicHighScorePositon>0:
		$"EndGameText".text=tr("PublishScoreQuestion") % GameState.publicHighScorePositon
	else:
		$"EndGameText".text=tr("PublishQuarterScoreQuestion") % GameState.publicQuarterHighScorePositon
		
	show_modal(true)
	$NameContainer/Name.grab_focus()	

func storeScoreNames():
	Settings.highScoreName=_nameTextBox.text;
	Settings.highScoreClub=_clubTextBox.text;
	GameEvents.settingsChanged()
func readScoreNames():
	_nameTextBox.text=Settings.highScoreName;
	_clubTextBox.text=Settings.highScoreClub;
	
func _on_PublishScore_pressed():
	var name=_nameTextBox.text
	if name.length()>0:
		var club= _clubTextBox.text;
		if club!=null && club!='':
			name=name+" / "+club;
		storeScoreNames()
		publishScore(name,GameState.game_time_elapsed,false)
	else:
		$"NameRequiredError".visible=true;

func publishScore(name,highScore,testOnly):
	$"ErrorText".visible=false
	var score=int(highScore*1000)
	var hashValue= CalcSecurityCode.calcHashScore(name,0,score)
	var url=Constants.serverUrl+"/newGameHighScore?data[game]=1&data[level]=0"
	url=url+"&data[hash]="+hashValue
	url=url+"&data[name]="+name.percent_encode()
	url=url+"&data[score]="+str(score)
	if testOnly:
		url=url+"&data[checkOnly]=true" 
	else:
		url=url+"&data[checkOnly]=false" 
	testScore=testOnly
	$HTTPRequest.request(url, [], true, HTTPClient.METHOD_GET)

func _on_PublishScoreContine_pressed():
	statEndGameDialog()

func _onUploadRequest(result, response_code, headers, body):
	var text=body.get_string_from_utf8()
	var rank=-1
	var quarterRanking=-1
	if response_code==200:
		var json = JSON.parse(text)
		rank=json.result.ranking
		quarterRanking=json.result.quarterRanking
	if testScore:		
		GameState.publicHighScorePositon=rank
		GameState.publicQuarterHighScorePositon=quarterRanking
		if GameState.publicHighScorePositon>0 || GameState.publicQuarterHighScorePositon>0:
			$"../PublishHighscoreCollectGame".start()
		else :
			$"../EndCollectGame".show_modal(true)
	else:
		if response_code==501:
			$"ErrorText".text=text
			$"ErrorText".visible=true
		else:
			visible=false
			$"../HighScores".start()
