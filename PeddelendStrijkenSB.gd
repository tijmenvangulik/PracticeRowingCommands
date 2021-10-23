extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _pressed():
	var boat=$"../../../../Boat"
	boat.doCommand(boat.Command.PeddelendStrijkenSB)
