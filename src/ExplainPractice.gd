extends WindowDialog

var _explainText=""

func _ready():
	get_close_button().hide()
	GameEvents.connect("languageChangedSignal",self,"_on_languageChanged")
	
# Called when the node enters the scene tree for the first time.
func showDialog(explainText):
	_explainText=explainText
	showText()
	
func showText():
	var text=tr(_explainText);
	if text!=null && text!="" && text!=_explainText :
		$PracticeExplain.set_bbcode(Utilities.replaceCommandsInText(text,true))
		visible=true
	
func _on_Start_pressed():
	hide()

func _on_languageChanged():
	if visible:
		showText()
