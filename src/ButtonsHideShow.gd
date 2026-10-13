extends Button

# hide or show the command buttons (Settings.hideCommandButtons), only possible when the commands can be spoken

var	icon_hide=preload( "res://assets/hide.png")
var	icon_show=preload( "res://assets/show.png")

# anchors and margins of the position while the command buttons are shown
var normalLayout=[]

func _ready() -> void:
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	if !GameState.mobileMode:
		GameEvents.register_allways_tooltip(self,"HideCommandButtons")
	updateState()
	if !Utilities.speechRecognitionSupported():
		visible=false
	else:
		# deferred, so EditButtons and Speak have their (mobile) position and size
		call_deferred("initLayout")

func initLayout():
	if GameState.mobileMode:
		# in mobile mode this button replaces the EditButtons button, with the size of the speak button
		setLayout(getLayout($"%EditButtons"))
		rect_size=$"%Speak".rect_size
	normalLayout=getLayout(self)
	updatePosition()

func getLayout(control : Control):
	return [control.anchor_left,control.anchor_top,control.anchor_right,control.anchor_bottom,
		control.margin_left,control.margin_top,control.margin_right,control.margin_bottom]

func setLayout(layout):
	anchor_left=layout[0]
	anchor_top=layout[1]
	anchor_right=layout[2]
	anchor_bottom=layout[3]
	margin_left=layout[4]
	margin_top=layout[5]
	margin_right=layout[6]
	margin_bottom=layout[7]

# when the command buttons are hidden: desktop on the place of the EditButtons button,
# mobile on the normal place of the speak button (top right)
func updatePosition():
	if normalLayout.empty():
		return
	if !Utilities.commandButtonsHidden():
		setLayout(normalLayout)
	elif GameState.mobileMode:
		var speakLayout=$"%Speak".normalLayout
		if !speakLayout.empty():
			setLayout(speakLayout)
	else:
		setLayout(getLayout($"%EditButtons"))

func _highContrastChangedSignal(highContrast):
	Styles.SetRoundedButtonStyle(self)

func setVisible(show : bool):
	# not in step by step mode, there the command buttons are always shown
	visible=show && Utilities.speechRecognitionSupported() && !GameState.replayStepByStep
	updateState()
	updatePosition()

# pressed when the command buttons are hidden, the icon shows the state of the buttons
func updateState():
	if pressed!=Settings.hideCommandButtons:
		pressed=Settings.hideCommandButtons
	set_button_icon(icon_hide if Settings.hideCommandButtons else icon_show)

func _on_ButtonsHideShow_toggled(button_pressed: bool) -> void:
	if button_pressed==Settings.hideCommandButtons:
		# changed from code (updateState)
		return
	Settings.hideCommandButtons=button_pressed
	$"%ButtonsContainer".updateVisibility()
	$"%SettingsDialog".saveSettings()
