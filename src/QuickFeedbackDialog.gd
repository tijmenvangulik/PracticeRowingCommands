extends WindowDialog


# 
enum SmlileyState {Sad,Meh,Smile,Love}
var smlileyState = SmlileyState.Meh

var saveState = "Meh"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()

func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");


func _on_CancelFeedback_pressed():
	hide()

func _on_SendFeedback_pressed():
	var text=$Comment.text.percent_encode()
	var url=Constants.serverUrl+"/sendFeedback?data[smiley]="+saveState
	url=url+"&data[app]=prc&data[text]="+text
	
	$HTTPRequest.request(url, [], true, HTTPClient.METHOD_GET)

	hide()

func updateEmoticon():
	$"EmoticonSelection/Sad".pressed=smlileyState==SmlileyState.Sad
	$"EmoticonSelection/Meh".pressed=smlileyState==SmlileyState.Meh
	$"EmoticonSelection/Smile".pressed=smlileyState==SmlileyState.Smile
	$"EmoticonSelection/Love".pressed=smlileyState==SmlileyState.Love
		
func _on_Sad_pressed():
	smlileyState=SmlileyState.Sad
	saveState="Bad"
	updateEmoticon()

func _on_Meh_pressed():
	smlileyState=SmlileyState.Meh
	saveState="Meh"
	updateEmoticon()


func _on_Smile_pressed():
	smlileyState=SmlileyState.Smile
	saveState="Good"
	updateEmoticon()
	

func _on_Love_pressed():
	smlileyState=SmlileyState.Love
	saveState="Love"
	updateEmoticon()
