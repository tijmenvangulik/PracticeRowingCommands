extends CenterContainer


var waitingCommand : int
var resumeObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("doCheckCommand",self,"checkCommand")
	GameEvents.connect("windowSizeChanged",self,"_sizeChanged");
	
func setSizeText():
	if GameState.mobileMode:
		var buttonContainerWidth=$"%ButtonsContainer".rect_size.x
		var viewPortWidht=get_viewport_rect().size.x
		var newWidth=viewPortWidht-buttonContainerWidth-15
		#$Label.autowrap=true
		$Label.rect_min_size.x=newWidth
		$Label.align=Label.ALIGN_LEFT
		$Label.valign=Label.VALIGN_TOP
		$Label.autowrap=true 
		$Label.rect_position.x=0
		$"%StepByStep".rect_position.x=10
		$"%StepByStep".rect_size.x=newWidth
		
func _sizeChanged():
	if $"%StepByStep".visible:
		setSizeText()

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
	setSizeText()
	
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
