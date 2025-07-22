extends WindowDialog

var _explainText=""
var _practice=-1
var _showLessButtonsArray=[]

func _ready():
#	get_close_button().hide()
	GameEvents.connect("languageChangedSignal",self,"_on_languageChanged")
	if GameState.mobileMode:
		var extraSize=100
		margin_left-=extraSize
		margin_right+=extraSize
		margin_bottom+=50
		
		$PracticeExplain.margin_right+=extraSize*2
		$HBoxContainer.margin_top-=10
		$HBoxContainer.margin_bottom-=10

func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		visible=false
	
# Called when the node enters the scene tree for the first time.
func showDialog(startItemPos,showLessButonsArray):
	_practice=$"%OptionStart".currentStartPos
	$HBoxContainer/StartDemo.visible=$"%Recorder".hasDemo(_practice)
	var recorder=$"%Recorder";
	if GameState.isReplaying:
		_on_StartLessButtons_pressed()
	else:
		_explainText=Practices.getPracticeExplainText(startItemPos)
		_showLessButtonsArray=showLessButonsArray
		showText()
		show_modal(true)
		$HBoxContainer/StartLessButtons.grab_focus()
	
func showText():
	var title=Practices.getTranslatedPracticeName(_practice)
	var text="[color=#84a9c9][u]"+tr(title)+"[/u][/color]\n"
	text=text+tr(_explainText);
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
