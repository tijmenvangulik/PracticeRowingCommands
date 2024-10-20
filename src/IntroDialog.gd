extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lang=""

func handleShow():
	GameState.dialogIsOpen=visible
	if visible:
		$"HSplitContainer/CloseButton".grab_focus()
		
func _init():
	connect("visibility_changed",self,"handleShow");
	GameEvents.connect("settingsLoadedSignal",self,"_settingsLoaded");

# Called when the node enters the scene tree for the first time.
func _ready():
	setText()
	get_close_button().hide()
	
func setText():
	var intro=$"IntroText"
	intro.set_bbcode(tr("IntroText"))
	var links=$"Links"
	links.set_bbcode(tr("Links"))
	lang=TranslationServer.get_locale()

func _process(delta):
	if lang!=TranslationServer.get_locale():
		setText()

func _settingsLoaded():
	# when there is not yet a language then
	# use aseparate dialog for choosing the dialog
	if !GameState.languageSetFromSettingsOrUl:
		$"%RightTopButtons".visible=false
		$"%ButtonsContainer".visible=false
		GameEvents.intro(true)
		$"%ChooseLanguage".show_modal(true)
	else:
		start()

func hideShowControls(visible):
	$"%ButtonsContainer"	.visible=visible
	$"%TooltipHelp".visible=visible
	
func start():
	hideShowControls(false)
	visible=true;
	GameEvents.intro(true)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func closeIntro():
	hideShowControls(true)
	GameEvents.intro(false)
	visible=false;

func _on_StartPractices_pressed():
	closeIntro()
	$"%OptionStart".startPractices()

