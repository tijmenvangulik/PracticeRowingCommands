extends Node2D

func _init():
   TranslationServer.set_locale("nl_NL")
	
# jp is dutch viking

func _ready():
	$"CanvasLayer/IntroDialog".visible=true
	$"CanvasLayer/OptionStart".visible=false
	$"CanvasLayer/OptionCommands".visible=false
	$"CanvasLayer/SettingsButton".visible=false
	$"CanvasLayer/ButtonsContainer".visible=false
#	$"CanvasLayer/".visible=false
	#loadSettings();
	
func set_camera_limits():
	var map_limits = $TileMap.get_used_rect()
	var map_cellsize = $TileMap.cell_size


