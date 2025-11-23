extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")

func _on_CancelGame_pressed():
	self.visible=false;
	GameState.changeCollectGameState( Constants.CollectGameState.None)
	$"%OptionStart".startOnWater()

func _on_StartGame_pressed():
	self.visible=false;
	GameState.changeCollectGameState( Constants.CollectGameState.DoStart)


func init(time:String,isHighScore:bool):
	var text=tr("EndGameAllFound") % time
	if isHighScore:
		text=tr("EndGameHighScore") % time
	$Trophy.visible=isHighScore
	$Trophy2.visible=isHighScore
	$Star4.visible=!isHighScore
	$Star5.visible=!isHighScore
	$Sad	.visible=false
	$Sad2.visible=false
	
	$EndGameText.text=text

func initCrashed():
	var text=tr("GameOverCrash")
	$EndGameText.text=text
	$Trophy.visible=false
	$Trophy2.visible=false
	$Star4.visible=false
	$Star5.visible=false
	$Sad	.visible=true
	$Sad2.visible=true
	
func _collectGameStateChangedSignal(state):
	if state==Constants.CollectGameState.Crashed:
		initCrashed()
		show_modal(true)
	elif state==Constants.CollectGameState.Finished:
		init(GameState.collectGameLastTimeString,GameState.collectGameIsHighScore)
		#test if it is an high score
		$"../PublishHighscoreCollectGame".publishScore("",GameState.game_time_elapsed,true)
		# here first test if it is an public high score
		
	$HBoxContainer/StartGame.grab_focus()


