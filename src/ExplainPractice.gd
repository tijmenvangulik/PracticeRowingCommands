extends WindowDialog

func _ready():
	get_close_button().hide()

# Called when the node enters the scene tree for the first time.
func showDialog(explainText):
	var text=tr(explainText);
	if text!=null && text!="" && text!=explainText :
		$PracticeExplain.set_bbcode(Utilities.replaceCommandsInText(text,true))
		visible=true
	
func _on_Start_pressed():
	hide()
