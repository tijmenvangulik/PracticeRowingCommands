extends Node2D
	
	
# jp is dutch viking

func setVisibleControlButtons(visible):
	$"CanvasLayer/RightTopButtons/OptionStart".visible=visible
	$"CanvasLayer/OptionCommands".visible=visible
	$"CanvasLayer/RightTopButtons/SettingsButton".visible=visible
	$"CanvasLayer/ButtonsContainer".visible=visible
	$"CanvasLayer/RightTopButtons/ZoomContainer".visible=visible
	$"CanvasLayer/RightTopButtons/ForwardsBackwards".visible=visible
	
	
func _ready():
	$"CanvasLayer/IntroDialog".visible=true
	setVisibleControlButtons(false)
	var styleDropDown= preload("res://MainDropDown.tres")
	$"CanvasLayer/RightTopButtons/OptionStart".get_popup().add_stylebox_override("panel",styleDropDown)
	$"CanvasLayer/RightTopButtons/OptionLanguage".get_popup().add_stylebox_override("panel",styleDropDown)
	$"CanvasLayer/OptionCommands".get_popup().add_stylebox_override("panel",styleDropDown)
#	$"CanvasLayer/".visible=false
	#loadSettings();
	
func set_camera_limits():
	var map_limits = $TileMap.get_used_rect()
	var map_cellsize = $TileMap.cell_size


