extends Label


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("showMobileTooltip",self,"_showMobileTooltip")
	visible=GameState.mobileMode
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	
func _showMobileTooltip(tooltipText):
	text=tooltipText

func clearMobileTooltip():
	text=""
func _highContrastChangedSignal(highContrast):
	if highContrast:
		add_color_override("font_color",Color(0,0,0))
	else:
		remove_color_override("font_color")
