extends Button



func _ready() -> void:
	GameEvents.register_tooltip(self,"ModifyButtons")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	if GameState.mobileMode:
		rect_position.y=2
		margin_top=16
		anchor_top=0
		margin_right=-50
	
func _on_EditButtons_pressed() -> void:
	$"%SettingsDialog".start(3)

func setStyleButtons():
	Styles.SetRoundedButtonStyle(self)
	

func _highContrastChangedSignal(highContrast):
	setStyleButtons();
