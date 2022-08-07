extends Node

class_name Ducks

export (NodePath) onready var boat = get_node(boat) as Boat

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gameRunning=false;
var duckScene = preload("res://Duck.tscn")
var ducks=[];
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("collectGameStateChangedSignal",self,"_collectGameStateChangedSignal")

func doStartGame():
	gameRunning=true
	spawnNewDuck($"DuckPath")
	spawnNewDuck($"Duck2Path")

func stopGame():
	if gameRunning:
		if (boat.crashState):
			# wait a bit so the user can see the crash
			var t=boat.startTimer(1.1)
			yield(t, "timeout")
			boat.removeTimer(t)
			doStopGame()
			
		else: 
			doStopGame()
		
		
func doStopGame():
	removeDucks()
	gameRunning=false
	$"Duck".stop()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _collectGameStateChangedSignal(state):

	if state==Constants.CollectGameState.DoStart:
		doStartGame()
	elif state==Constants.CollectGameState.Start:
		stopGame()
	elif state==Constants.CollectGameState.Stop:
		stopGame()	
	elif state==Constants.CollectGameState.Finish:
		stopGame()
		
func removeDucks():
	for i in ducks.size():		
		ducks[i].stop()
		ducks[i].queue_free()		
	ducks=[]
	
func spawnNewDuck(new_patrol_path):
	var duck=duckScene.instance() as Duck
	duck.visible=false;
	ducks.push_front(duck)
	get_parent().add_child(duck)
	duck.call_deferred("initDuck",new_patrol_path)
	return duck
