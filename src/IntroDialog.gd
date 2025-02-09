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
		return value
	return "0.0.0"


func _init():
	connect("visibility_changed",self,"handleShow");
	GameEvents.connect("settingsLoadedSignal",self,"_settingsLoaded");
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	setText()
	get_close_button().hide()
	$VersionNumber.text=get_version();
	
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
		$"%ButtonsContainer".visible=false
		setIntroState(true)
		$"%ChooseLanguage".showDialog()
	else:
		start()

func hideShowControls(visible):
	$"%ButtonsContainer"	.visible=visible
	$"%TooltipHelp".visible=visible
	
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
