extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	setStyleButtons()

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
