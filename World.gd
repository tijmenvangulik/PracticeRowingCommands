extends Node2D

func _init():
   TranslationServer.set_locale("nl_NL")
	
# jp is dutch viking

func _ready():
	$"CanvasLayer/IntroDialog".visible=true
	$"CanvasLayer/OptionStart".visible=false
	$"CanvasLayer/OptionCommands".visible=false
	#loadSettings();
	
func set_camera_limits():
	var map_limits = $TileMap.get_used_rect()
	var map_cellsize = $TileMap.cell_size

func getSettings():
    var save_dict = {
        "test" : "flap"
    }
    return save_dict
	
func setSettings(dict):
	pass
		
func saveSettings():
	var save_game = File.new()
	save_game.open("user://settings.save", File.WRITE)
	var settings=getSettings()
	save_game.store_line(to_json(settings))
	save_game.close()
	
func loadSettings():
	var save_game = File.new()
	if not save_game.file_exists("user://settings.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://settings.save", File.READ)
	while save_game.get_position() < save_game.get_len():
        # Get the saved dictionary from the next line in the save file
		var dict = parse_json(save_game.get_line())
		setSettings(dict)
	save_game.close()
