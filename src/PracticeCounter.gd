extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")

func _introSignal(isVisible : bool):
	visible=!isVisible
	
func setCount(value,maxValue):
	$"CountPractices".text=String(value)+" / "+String(maxValue)


func _highContrastChangedSignal(highContrast):
	
	Styles.setFontColorOverride($CountPractices)
