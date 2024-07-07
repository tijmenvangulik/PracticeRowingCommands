extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var	icon_on=preload( "res://assets/HD-on.png")
var	icon_off=preload( "res://assets/HD-off.png")



# Called when the node enters the scene tree for the first time.
#func _ready():

func _on_HdButton_toggled(button_pressed):
	if self.pressed:
		set_button_icon(icon_on)
	else:
		set_button_icon(icon_off)
	# here some how swtich to hd in the future
	#if DisplayServer.screen_get_dpi(0) > 120:
	#	ProjectSettings.set('display/window/stretch/scale', 2.0)
	
	
