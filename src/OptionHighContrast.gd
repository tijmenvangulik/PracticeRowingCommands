extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	if GameState.mobileMode:
		$OptionHighContrastHorz.margin_top=2
	
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


func _on_HighContrastLabel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouseEvent= event as InputEventMouseButton
		if mouseEvent.pressed:
			$OptionHighContrastHorz/HighContrastSwitch.pressed=!$OptionHighContrastHorz/HighContrastSwitch.pressed
