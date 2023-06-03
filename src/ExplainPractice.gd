extends WindowDialog

var _explainText=""

var _showLessButtonsArray=[]

func _ready():
	get_close_button().hide()
	GameEvents.connect("languageChangedSignal",self,"_on_languageChanged")

func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");

# Called when the node enters the scene tree for the first time.
func showDialog(explainText,showLessButonsArray):
	_explainText=explainText
	_showLessButtonsArray=showLessButonsArray
	showText()
	
func showText():
	var text=tr(_explainText);
	if text!=null && text!="" && text!=_explainText :
		$PracticeExplain.set_bbcode(Utilities.replaceCommandsInText(text,true))
		visible=true
		$HBoxContainer/StartLessButtons.grab_focus()
	
func _on_Start_pressed():
	hide()
	GameEvents.startPlay()

func _on_StartLessButtons_pressed():
	Utilities.showOnlyButtons(_showLessButtonsArray)
	hide()
	GameEvents.startPlay()


func _on_languageChanged():
	if visible:
		showText()
