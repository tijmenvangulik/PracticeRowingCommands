extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")

func calcSize():
	rect_min_size.x=$OptionHighContrastHorz/HighContrastSwitch.rect_size.x+10+$OptionHighContrastHorz/HighContrastLabel.rect_size.x

func _introSignal(showIntro):
	visible=showIntro
	if showIntro:
		calcSize()
		setStyle()
		$OptionHighContrastHorz/HighContrastSwitch.pressed=Settings.highContrast


func _on_HighContrastSwitch_toggled(button_pressed):
		Settings.highContrast=$OptionHighContrastHorz/HighContrastSwitch.pressed
		GameEvents.settingsChanged()
		GameEvents.highContrastChanged(Settings.highContrast)
		setStyle()

func _highContrastChangedSignal(highContrast):
	setStyle()
	
func setStyle():
	Styles.SetPanelDropDownStyle(self)
