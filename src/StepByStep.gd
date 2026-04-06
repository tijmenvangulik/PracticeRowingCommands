extends CenterContainer


var waitingCommand : int
var resumeObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("doCheckCommand",self,"checkCommand")

func start(practice : int):
	$"%ButtonsContainer".visible=false
	GameState.replayStepByStep=true
	$"%Recorder".replayDemo(practice,false,true)
	$"%Pause".visible=false
	
func stop():
	GameState.replayStepByStep=false
	visible=false
	$"%ButtonsContainer".visible=true
	if GameState.pause_mode:
		resumeStep()
		$"%Pause".setPaused(false)
	$"%Recorder".cancelReplay()
	$"%Pause".visible=true
	
func waitStep(command : int,resumeObj):
	$Label.text="StepByStepNextCommand"
	waitingCommand=command
	resumeObject=resumeObj
	$"%Pause".setPaused(true,false)
	visible=true
	$"%ButtonsContainer".visible=true
	
func resumeStep():
	$"%Pause".setPaused(false)
	visible=false
	resumeObject.emit_signal("resumeStep")
	$"%ButtonsContainer".visible=false

func checkCommand(command : int):
	if command==waitingCommand:
		waitingCommand=-1
		resumeStep()
	else:
		$Label.text="StepByStepWrongcommand"
