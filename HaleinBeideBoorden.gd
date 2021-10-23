extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _pressed():
	var boat=$"../../../../Boat"
	boat.changeState(boat.RowState.HalenBeideBoorden,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
