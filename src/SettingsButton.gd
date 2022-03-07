extends ToolButton

export (NodePath) onready var settingsDialog = get_node(settingsDialog) as WindowDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_tooltip(self,"SettingsButtonTooltip")

func _introSignal(isVisible : bool):
	visible=!isVisible

func _pressed():
	settingsDialog.popup()
