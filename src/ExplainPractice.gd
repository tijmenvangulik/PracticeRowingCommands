extends WindowDialog

var _explainText=""

var _showLessButtonsArray=[]

func _ready():
#	get_close_button().hide()
	GameEvents.connect("languageChangedSignal",self,"_on_languageChanged")

func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		visible=false
	
# Called when the node enters the scene tree for the first time.
func showDialog(explainText,showLessButonsArray):
	var practice=$"%OptionStart".currentStartPos
	$HBoxContainer/StartDemo.visible=$"%Recorder".hasDemo(practice)
	var recorder=$"%Recorder";
	if GameState.isReplaying:
		_on_StartLessButtons_pressed()
	else:
		_explainText=explainText
		_showLessButtonsArray=showLessButonsArray
		showText()
		show_modal(true)
		$HBoxContainer/StartLessButtons.grab_focus()
	
func showText():
	var text=tr(_explainText);
	if text!=null && text!="" && text!=_explainText :
		$PracticeExplain.set_bbcode(Utilities.replaceCommandsInText(text,true))
	
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


func _on_StartDemo_pressed():
	hide()
	var practice=$"%OptionStart".currentStartPos
	$"%Recorder".replayDemo(practice)
	


func _on_SkipPractice_pressed():
	visible=false
	$"%OptionStart".skipPractice()
