extends WindowDialog

class_name StartCollectGame

export (NodePath) onready var collectables = get_node(collectables) as Collectables

# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")

func _on_CancelGame_pressed():
	self.visible=false;
	GameState.changeCollectGameState( Constants.CollectGameState.None)


func _on_StartGame_pressed():
	self.visible=false;
	GameState.changeCollectGameState( Constants.CollectGameState.DoStart)

func init():
	var text=tr("StartGameIntro")
	$GameIntroText.text=text
	
func _collectGameStateChangedSignal(state):
	if state==Constants.CollectGameState.Start:
		init()
		show_modal(true)
	
