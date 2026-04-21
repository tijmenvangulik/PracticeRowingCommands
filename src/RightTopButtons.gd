extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	GameEvents.connect("introSignal",self,"_introSignal")
	setStyleButtons()
	if GameState.mobileMode:
		add_constant_override("separation",10)
		margin_left=20
		_introSignal(false)

func _introSignal(isVisible : bool):
	if GameState.mobileMode:
		if isVisible:
			margin_top=14
			margin_bottom=38
		else:
			margin_top=20
			margin_bottom=66
		

func _highContrastChangedSignal(highContrast):
	setStyleButtons()

func setStyleButtons():
	Styles.SetStartButtonStyle($"%OptionStart")
	Styles.SetMainDropDownStyle($"%OptionLanguage")
	Styles.SetMainDropDownStyle($HdButton)
	Styles.SetMainDropDownStyle($"%TooltipHelp")
	Styles.SetMainDropDownStyle($SettingsButton)
	Styles.SetMainDropDownStyle($FeedbackButton)
	Styles.SetMainDropDownStyle($ZoomContainer/ZoomPlus)
	Styles.SetMainDropDownStyle($ZoomContainer/ZoomMin)
	Styles.SetMainDropDownStyle($ForwardsBackwards)
	Styles.SetMainDropDownStyle($FullScreen)
	Styles.SetMainDropDownStyle($"%Pause")
	
