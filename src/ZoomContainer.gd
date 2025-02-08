extends HBoxContainer


export (NodePath) onready var camera = get_node(camera) as Camera2D

var newZoom=-1
var step=0.5

func _ready():
	GameEvents.connect("settingsChangedSignal",self,"_settings_changed_signal")
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")

func _introSignal(isVisible : bool):
	visible=!isVisible
	
func directSetZoom(zoom):
	if camera.zoom.x!=Settings.zoom:
		camera.zoom.x=zoom
		camera.zoom.y= zoom
		newZoom=-1
		GameEvents.zoomChanged()
		if zoom>0 && zoom<100:
			Settings.zoom=zoom
			GameEvents.settingsChanged()
	
func _process(delta):
	if newZoom!=-1:
		
		if camera.zoom.x< newZoom:
			camera.zoom.x+=delta*step
			camera.zoom.y= camera.zoom.x
			if camera.zoom.x>=newZoom:
				directSetZoom(newZoom)
		
		if camera.zoom.x> newZoom:
			camera.zoom.x-=delta*step
			camera.zoom.y= camera.zoom.x
			if camera.zoom.x<=newZoom:
				directSetZoom(newZoom)
		
func zoom(delta):
	newZoom=camera.zoom.x+delta*0.1

func _on_ZoomPlus_pressed():
	zoom(-1)

func _on_ZoomMin_pressed():
	zoom(1)

func _settings_changed_signal():
	if Settings.zoom>0 && camera.zoom.x!=Settings.zoom:
		camera.zoom.x=Settings.zoom
		camera.zoom.y=Settings.zoom
		GameEvents.zoomChanged()

func _highContrastChangedSignal(highContrast):
	
	Styles.setFontColorOverride($ZoomLabel)
