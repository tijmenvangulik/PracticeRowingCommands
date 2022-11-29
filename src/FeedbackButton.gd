extends Button

export (NodePath) onready var feedbackDialog = get_node(feedbackDialog) as WindowDialog

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_allways_tooltip(self,"QuickFeedback")

func _introSignal(isVisible : bool):
	visible=!isVisible

func _pressed():
	feedbackDialog.show()
