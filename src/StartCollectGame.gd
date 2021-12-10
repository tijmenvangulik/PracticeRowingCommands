extends WindowDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()

func _on_CancelGame_pressed():
	self.visible=false;


func _on_StartGame_pressed():
	self.visible=false;
	$"../../Collectables".doStartGame()

func init():
	var text=tr("StartGameIntro")
	$GameIntroText.text=text
