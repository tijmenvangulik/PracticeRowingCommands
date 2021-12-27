extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func zoom(delta):
	var camera=$"../../Boat/Camera2D2"
	var newZoom=camera.zoom.x+delta*0.1
	if newZoom>0 && newZoom<100:
		camera.zoom.x= newZoom
		camera.zoom.y= newZoom
		$"../../Boat".setForwardsPosition(0)
		$"../SettingsDialog".saveSettings()

func _on_ZoomPlus_pressed():
	zoom(-1)


func _on_ZoomMin_pressed():
	zoom(1)
