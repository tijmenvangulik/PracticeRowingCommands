extends Button



func _ready() -> void:
	GameEvents.register_tooltip(self,"ModifyButtons")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	var offset=90
	if !Utilities.speechRecognitionSupported():
		offset=20
	if GameState.mobileMode:
		rect_position.y=2
		margin_top=20
		anchor_top=0
		margin_left-=offset
		margin_right-=offset
		rect_size.x+=12
		rect_size.y+=12;	

func _on_EditButtons_pressed() -> void:
	$"%SettingsDialog".start(3)

func setStyleButtons():
	Styles.SetRoundedButtonStyle(self)
	

func _highContrastChangedSignal(highContrast):
	setStyleButtons();
