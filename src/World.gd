extends Node2D

func _init():
   TranslationServer.set_locale("nl_NL")
	
# jp is dutch viking

func setVisibleControlButtons(visible):
	$"CanvasLayer/OptionStart".visible=visible
	$"CanvasLayer/OptionCommands".visible=visible
	$"CanvasLayer/SettingsButton".visible=visible
	$"CanvasLayer/ButtonsContainer".visible=visible
	$"CanvasLayer/ZoomContainer".visible=visible
	
func _ready():
	$"CanvasLayer/IntroDialog".visible=true
	setVisibleControlButtons(false)

#	$"CanvasLayer/".visible=false
	#loadSettings();
	
func set_camera_limits():
	var map_limits = $TileMap.get_used_rect()
	var map_cellsize = $TileMap.cell_size


