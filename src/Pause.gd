extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


var pauseSprite=load("res://assets/pause.png")
var playSprite=load("res://assets/play.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_allways_tooltip(self,"PauseTooltip")
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")

func updateIcon():
	if pressed:
		icon=playSprite
	else:
		icon=pauseSprite 
	
func hideShowWater(doShow):
	var water=$"%WaterClasicFrozen";
	if water.visible!=doShow:
		if doShow:
			$"%WaterClasicFrozenAnimation".play("FrozenFadeIn")
		else:
			$"%WaterClasicFrozenAnimation".play("FrozenFadeOut")
			
func _on_ToolButton_pressed() -> void:
	setPaused(!GameState.isPaused)
	 
func setPaused(value,frozenWater=true):
	if GameState.isPaused!=value:
		GameState.isPaused=value;
		get_tree().set_pause(value)
		pressed=value;
		updateIcon()
		if frozenWater:
			hideShowWater(value)
		else:
			hideShowWater(false)
	
func _on_Pause_toggled(button_pressed: bool) -> void:
  setPaused(button_pressed)

func _introSignal(isVisible : bool):
	visible=!isVisible

func _collectGameStateChangedSignal(state):
	if state==Constants.CollectGameState.DoStart || state==Constants.CollectGameState.Start:
		visible=false
		setPaused(false)
	elif state==Constants.CollectGameState.Stop || state==Constants.CollectGameState.Finish:
			visible=true
