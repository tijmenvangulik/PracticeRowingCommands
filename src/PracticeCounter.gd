extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("introSignal",self,"_introSignal")

func _introSignal(isVisible : bool):
	visible=!isVisible
	
func setCount(value,maxValue):
	$"CountPractices".text=String(value)+" / "+String(maxValue)
