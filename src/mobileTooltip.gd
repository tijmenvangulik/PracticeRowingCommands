extends Label


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("showMobileTooltip",self,"_showMobileTooltip")
	visible=GameState.mobileMode
	
func _showMobileTooltip(tooltipText):
	text=tooltipText

func clearMobileTooltip():
	text=""
