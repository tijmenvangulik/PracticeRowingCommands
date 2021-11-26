extends GridContainer


signal button_droppedOnSourceGrid(droppedInfo)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func can_drop_data(_pos, data):
	return typeof(data) == TYPE_DICTIONARY && data["command"]!=null && data.dragButton.get_parent()!=self

func drop_data(_pos, data):
	emit_signal("button_droppedOnSourceGrid",data)
