extends Button



func _ready() -> void:
	GameEvents.register_tooltip(self,"ModifyButtons")
	
func _on_EditButtons_pressed() -> void:
	$"%SettingsDialog".start(3)
