extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var newZoom=-1
var step=0.5

func directSetZoom(zoom):
	var camera=$"../../../Boat/Camera2D2"
	camera.zoom.x=zoom
	camera.zoom.y= zoom
	newZoom=-1
	$"../../../Boat".setForwardsPosition(0)
	
func _process(delta):
	if newZoom!=-1:
		var camera=$"../../../Boat/Camera2D2"
		if camera.zoom.x< newZoom:
			camera.zoom.x+=delta*step
			camera.zoom.y= camera.zoom.x
			if camera.zoom.x>newZoom:
				directSetZoom(newZoom)
		
		if camera.zoom.x> newZoom:
			camera.zoom.x-=delta*step
			camera.zoom.y= camera.zoom.x
			if camera.zoom.x<newZoom:
				directSetZoom(newZoom)
		
func zoom(delta):
	var camera=$"../../../Boat/Camera2D2"
	newZoom=camera.zoom.x+delta*0.1
	if newZoom>0 && newZoom<100:
		$"../../SettingsDialog".saveSettings()

func _on_ZoomPlus_pressed():
	zoom(-1)


func _on_ZoomMin_pressed():
	zoom(1)
