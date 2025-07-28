extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lang=""

var inIntro=false

func handleShow():
	GameState.dialogIsOpen=visible
	if visible:
		$HSplitContainer/StartPractices.call_deferred("grab_focus")

func get_version():
	if OS.has_feature('JavaScript'):
		var value= JavaScript.eval("appVersion")
		if value==null:
			return "0.0.0"
		return value
	return "0.0.0"


func _init():
	connect("visibility_changed",self,"handleShow");
	GameEvents.connect("settingsLoadedSignal",self,"_settingsLoaded");
	GameEvents.connect("windowSizeChanged",self,"_sizeChanged");
	
# Called when the node enters the scene tree for the first time.
func _ready():
	setText()
	get_close_button().hide()
	$VersionNumber.text=get_version();
	
	if GameState.mobileMode:
		$IntroText.get_font("font", "Label").size = 24
		anchor_left=0.02
		anchor_right=0.98
		anchor_bottom=0.98
		anchor_top=0.5
		
func setText():
	var intro=$"IntroText"
	intro.set_bbcode(tr("IntroText"))
	var links=$"Links"
	links.set_bbcode(tr("Links"))
	lang=TranslationServer.get_locale()

func _process(delta):
	if lang!=TranslationServer.get_locale():
		setText()

func setIntroState(value : bool):
	inIntro=value
	GameEvents.intro(value)
	
func _settingsLoaded():
	# when there is not yet a language then
	# use aseparate dialog for choosing the dialog
#	if true:
	if !GameState.languageSetFromSettingsOrUl:
		$"%RightTopButtons".visible=false
		$"%ButtonsContainer".setVisible(false)
		setIntroState(true)
		$"%ChooseLanguage".showDialog()
	else:
		start()

func hideShowControls(visible):
	$"%ButtonsContainer".setVisible(visible)
	$"%TooltipHelp".visible=visible && !GameState.mobileMode
	

func setWidth():
	margin_right=0
	
func _sizeChanged():
	setWidth()

func start():
	hideShowControls(false)
	visible=true;
	if !inIntro:
		setIntroState(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func closeIntro():
	hideShowControls(true)
	setIntroState(false)
	visible=false;
	$"%OptionStart".doStart(Constants.StartItem.Start)


func _on_StartPractices_pressed():
	closeIntro()
	$"%OptionStart".startPractices()

func _on_VersionNumber_gui_input(event):
	if event is InputEventMouseButton:
		JavaScript.eval("window.open('https://github.com/tijmenvangulik/PracticeRowingCommands/commits/main/')")


func _on_VersionNumber_mouse_entered():
	$VersionNumber.add_color_override("font_color", Color("e3e2e2"));


func _on_VersionNumber_mouse_exited():
	$VersionNumber.add_color_override("font_color", Color("3d5469"));
