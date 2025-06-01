extends Button



func _ready() -> void:
	GameEvents.register_tooltip(self,"ModifyButtons")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	
func _on_EditButtons_pressed() -> void:
	$"%SettingsDialog".start(3)

func setStyleButtons():
	Styles.SetRoundedButtonStyle(self)

func _highContrastChangedSignal(highContrast):
	setStyleButtons();
