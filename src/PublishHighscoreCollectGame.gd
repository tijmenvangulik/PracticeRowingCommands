extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	$HTTPRequest.connect("request_completed", self, "_onUploadRequest")

func statEndGameDialog():
	visible=false
	$"../EndCollectGame".show_modal(true)

func start():
	$"NameRequiredError".visible=false;
	$"EndGameText".text=tr("PublishScoreQuestion") % GameState.publicHighScorePositon
	show_modal(true)
	
func _on_PublishScore_pressed():
	var name=$"NameContainer/Name".text
	if name.length()>0:
		publishScore(name,Settings.highScore)
	else:
		$"NameRequiredError".visible=true;

func publishScore(name,highScore):
	$"ErrorText".visible=false
	var score=int(highScore*1000)
	var hashValue= CalcSecurityCode.calcHashScore(name,0,score)
	var url="https://ergometer-space.org/manager/newGameHighScore?data[game]=1&data[level]=0"
	url=url+"&data[hash]="+hashValue
	url=url+"&data[name]="+name.percent_encode()
	url=url+"&data[score]="+str(score)
	url=url+"&data[checkOnly]=false" 
	
	$HTTPRequest.request(url, [], true, HTTPClient.METHOD_GET)

func _on_PublishScoreContine_pressed():
	statEndGameDialog()

func _onUploadRequest(result, response_code, headers, body):
	var text=body.get_string_from_utf8()
	if response_code==200:
		var json = JSON.parse(text)
		var rank=json.result.ranking
	if response_code==501:
		$"ErrorText".text=text
		$"ErrorText".visible=true
	else:
		visible=false
		$"../HighScores".start()
