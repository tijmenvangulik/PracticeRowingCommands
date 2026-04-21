extends Button

export (NodePath) onready var settingsDialog = get_node(settingsDialog) as WindowDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_allways_tooltip(self,"SettingsButtonTooltip")
	if GameState.mobileMode:
		$options_icon.offset.y+=16
		rect_min_size.x=80
		$options_icon.offset.x=44
	
	
func _introSignal(isVisible : bool):
	visible=!isVisible

func _pressed():
	settingsDialog.start(0)
