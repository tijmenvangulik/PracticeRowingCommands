extends ToolButton

export (NodePath) onready var settingsDialog = get_node(settingsDialog) as WindowDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("introSignal",self,"_introSignal")

func _introSignal(isVisible : bool):
	visible=!isVisible

func _pressed():
	settingsDialog.popup()
