extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()

func _on_CancelGame_pressed():
	self.visible=false;


func _on_StartGame_pressed():
	self.visible=false;
	$"../../Collectables".doStartGame()


func init(time:String,isHighScore:bool):
	var text=tr("EndGameAllFound") % time
	if isHighScore:
		text=tr("EndGameHighScore") % time
	$Trophy.visible=isHighScore
	$Trophy2.visible=isHighScore
	$Star4.visible=!isHighScore
	$Star5.visible=!isHighScore
			
	$EndGameText.text=text
	
func initCrashed():
	var text=tr("GameOverCrash")
	$EndGameText.text=text
	$Trophy.visible=false
	$Trophy2.visible=false
	$Star4.visible=false
	$Star5.visible=false
	
