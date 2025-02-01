extends Panel


enum SmlileyState {Sad,Meh,Smile,Love}
var smlileyState = SmlileyState.Meh

var saveState = ""

func sendFeedBack():
	var comment=$Comment.text;
	if saveState!="" && comment!="":
		
		Settings.successCount=1000 # never ask for feed back
		GameEvents.settingsChanged()
				
		var text=$Comment.text.percent_encode()
		var url=Constants.serverUrl+"/sendFeedback?data[smiley]="+saveState
		url=url+"&data[app]=prc&data[text]="+text		
		$HTTPRequest.request(url, [], true, HTTPClient.METHOD_GET)

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
