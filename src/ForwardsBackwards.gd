extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	setText()
	GameEvents.connect("forwardBackwardsChangedSignal",self,"_forwardBackwardsChangedSignal")
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_tooltip(self,"ForwardsBackwardsTooltip")
	
func _introSignal(isVisible : bool):
	visible=!isVisible
	
func setText():
	if GameState.isForwards: text="Backwards"
	else: text="Forwards"
	
# Called when the node enters the scene tree for the first time.
func _pressed():
	GameState.isForwards=!GameState.isForwards
	GameEvents.forwardBackwardsChanged()

func _forwardBackwardsChangedSignal():
	setText()

