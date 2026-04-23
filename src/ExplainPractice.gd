extends WindowDialog

var _explainText=""
var _practice=-1
var _showLessButtonsArray=[]

func _ready():
#	get_close_button().hide()
	GameEvents.connect("windowSizeChanged",self,"_sizeChanged");

	GameEvents.connect("languageChangedSignal",self,"_on_languageChanged")
	if GameState.mobileMode:
		anchor_left=0.02
		anchor_right=0.96
	
func handleShow():
	GameState.dialogIsOpen=visible
	Utilities.modifyCloseButton(self);

func setWidth():
	margin_right=0
	
func _sizeChanged():
	setWidth()
	
func _init():
	connect("visibility_changed",self,"handleShow");

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		visible=false
	
# Called when the node enters the scene tree for the first time.
func showDialog(startItemPos,showLessButonsArray):
	_practice=$"%OptionStart".currentStartPos
	
	var stepByStep= Practices.stepByStepPractices.find(startItemPos)>=0
	$CenterContainer/HBoxContainer/StartStepByStep.visible=stepByStep
	
	$CenterContainer/HBoxContainer/StartDemo.visible=$"%Recorder".hasDemo(_practice)
	var recorder=$"%Recorder";
	if GameState.isReplaying:
		_on_StartLessButtons_pressed()
	else:
		_explainText=Practices.getPracticeExplainText(startItemPos)
		_showLessButtonsArray=showLessButonsArray
		showText()
		show_modal(true)
		$CenterContainer/HBoxContainer/StartLessButtons.grab_focus()
		

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
	$"%Recorder".replayDemo(practice,false)
	


func _on_SkipPractice_pressed():
	visible=false
	$"%OptionStart".skipPractice()


func _on_StartStepByStep_pressed() -> void:
	hide()
	var practice=$"%OptionStart".currentStartPos
	$"%StepByStep".start(practice)
