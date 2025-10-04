extends Button

export (NodePath) onready var boat = get_node(boat) as Boat


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var isRecording = false

var recording_commands= []
var recording_time= []
var startTime = 0;
var jsonRecording = ""
var _replayTimer= null

func _init():
	GameEvents.connect("introSignal",self,"_introSignal")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func recordCommad(command : int):	
	var relativeTime=Time.get_ticks_usec()-startTime
	recording_commands.append(command)
	recording_time.append(relativeTime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func recordingChanged():	
	if isRecording: 
		recording_commands=[]
		recording_time=[]
		text="Stop"
		startTime=Time.get_ticks_usec()
	else: 
		text="Record"
		var save={
			"practice": $"%OptionStart".currentStartPos,
			"recording_commands": recording_commands,
			"recording_time": recording_time,
			"endTime":Time.get_ticks_usec()-startTime
		}
		var json=to_json(save)
		#json=json.replace("\\","\\\\")
		json=json.replace("\"","\\\"")
		print(json)
		jsonRecording=json;
		
	
func replay(json : String):
	GameState.isReplaying=true
	var commandReplayText=$"%replayCommandText"
	commandReplayText.visible=true
	commandReplayText.text=""
	$"%ButtonsContainer".enabled=false
	var saved : Dictionary=parse_json(json)
	var endTime=int(saved["endTime"])
	var practice=int( saved["practice"])
	var recording_commands=saved["recording_commands"];
	var recording_times=saved["recording_time"];
	var optionsStart=$"%OptionStart"

	optionsStart.doStart(practice)
	optionsStart.practiceIsActive=false
	
	if typeof(recording_commands)==TYPE_ARRAY:				
		doReplayRecord(0,recording_commands,recording_times,0,practice,endTime)

	
func hideCommandText(hideAfter):
	var t= Utilities.startTimer(hideAfter)
	yield(t, "timeout")
	Utilities.removeTimer(t)
	$"%replayCommandText".visible=false;
	
func doReplayRecord(i,recording_commands,recording_times,lastTime,practice,endTime):
	if i<recording_commands.size():
		var time=int(recording_times[i])
		var waitTime=float(time-lastTime)/1000000.0;
		_replayTimer= Utilities.startTimer(waitTime)
		
		if waitTime>2.2:
			hideCommandText(2.0)
			
		yield(_replayTimer, "timeout")
		Utilities.removeTimer(_replayTimer)
		_replayTimer=null
		if GameState.isReplaying:
			var command=int(recording_commands[i])
			boat.doCommand(command)
			
			if !GameState.backgroundReplay: 
				var commandName=Constants.commandNames[command]
				$"%ButtonsContainer".focusCommand(commandName)
				var commandReplayText=$"%replayCommandText"
				commandReplayText.text=Utilities.replaceCommandText(commandName)
				commandReplayText.visible=true
				
				var shotTooltipKey=commandName+"_shorttooltip"
				var shortTooltipText=tr(shotTooltipKey)
				if shortTooltipText!=shotTooltipKey:
					commandReplayText.text=shortTooltipText
			doReplayRecord(i+1,recording_commands,recording_times,time,practice,endTime)
		else:
			replayEnded(lastTime,practice,endTime)
	else:
		replayEnded(lastTime,practice,endTime)

func replayEnded(lastTime,practice,endTime):
	
	if GameState.backgroundReplay:
		return
	var optionsStart=$"%OptionStart"
	var commandReplayText=$"%replayCommandText"
	
	if  GameState.isReplaying:
		
		_replayTimer= Utilities.startTimer(float(endTime-lastTime)/1000000.0)
		yield(_replayTimer, "timeout")
		Utilities.removeTimer(_replayTimer)
		_replayTimer=null
		if !GameState.isReplaying:
			return
		
		boat.doCommand(Constants.Command.LaatLopen)
		commandReplayText.text=tr("EndDemo")
		_replayTimer= Utilities.startTimer(2.5)
		yield(_replayTimer, "timeout")
		Utilities.removeTimer(_replayTimer)
		_replayTimer=null
		
		GameState.isReplaying=false
		optionsStart.doStart(practice)
		
	$"%ButtonsContainer".enabled=true
	commandReplayText.visible=false
	
func stopRecording():
	if isRecording:
		isRecording=false
		recordingChanged()
		
func _on_Record_toggled(button_pressed):
	isRecording=button_pressed
	recordingChanged()


func _on_Replay_pressed():
	replay(jsonRecording)

func getDemo(practice : int):
	
	if practice==Constants.StartItem.StilleggenOefenening:
		return "{\"endTime\":24741566,\"practice\":1,\"recording_commands\":[30,0,8,1],\"recording_time\":[793027,15286191,18165205,22746927]}"
	if practice==Constants.StartItem.BochtOefenening:
		return "{\"endTime\":39249252,\"practice\":2,\"recording_commands\":[30,0,10,1,3,1,30],\"recording_time\":[859023,9591231,10904845,16908562,17946518,24081367,28657106]}"
	if practice==Constants.StartItem.AchteruitvarenOefenening:
		return "{\"endTime\":17507132,\"practice\":3,\"recording_commands\":[5,0,8,1],\"recording_time\":[1083377,9471499,11353349,15508393]}"
	
	#todo : this practice still has wrong dialog at end
	if practice==Constants.StartItem.AchteruitBochtOefenening:
		return "{\"endTime\":17996807,\"practice\":4,\"recording_commands\":[7,0,5],\"recording_time\":[1048286,6620116,8976585]}"
	if practice==Constants.StartItem.Aanleggen:
		return "{\"endTime\":39616047,\"practice\":5,\"recording_commands\":[30,25,0,20,10,1],\"recording_time\":[1026486,9381274,20652835,22594850,26002433,33514992]}"
	if practice==Constants.StartItem.AanleggenBB:
		return "{\"endTime\":39811480,\"practice\":19,\"recording_commands\":[30,25,0,21,9,1],\"recording_time\":[938407,12110992,20332284,22111907,24013594,30872625]}"
	
	if practice==Constants.StartItem.AanleggenWal:
		if GameState.isScull:
		    return "{\"endTime\":33749327,\"practice\":8,\"recording_commands\":[30,25,0,18,10,1],\"recording_time\":[978477,2776212,14046524,15512073,17039580,24109740]}"
		else:
			return "{\"endTime\":31184142,\"practice\":8,\"recording_commands\":[30,25,0,32,10,10,1,1],\"recording_time\":[2261241,9414567,13557799,15150357,17263784,17564205,23206055,24132887]}"
		   # return "{\"endTime\":33749327,\"practice\":8,\"recording_commands\":[30,25,0,32,10,1],\"recording_time\":[978477,2776212,14046524,15512073,17039580,24109740]}"
	if practice==Constants.StartItem.AangelegdUitzetten:
		return "{\"endTime\":17807845,\"practice\":16,\"recording_commands\":[13,3,1,8,30],\"recording_time\":[1259870,3562523,6307884,8362506,9635747]}"
	if practice==Constants.StartItem.AangelegdUitzettenBB:
		return "{\"endTime\":17807845,\"practice\":21,\"recording_commands\":[14,4,1,8,30],\"recording_time\":[1259870,3562523,6307884,8362506,9635747]}"
	if practice==Constants.StartItem.Aangelegd:
		return  "{\"endTime\":32715542,\"practice\":6,\"recording_commands\":[11,1,23,7,1,30],\"recording_time\":[1210222,7357798,8721827,11092707,18236843,20845239]}"
	if practice==Constants.StartItem.AangelegdBB:
		return  "{\"endTime\":32715542,\"practice\":20,\"recording_commands\":[12,1,24,6,1,30],\"recording_time\":[1210222,7357798,8721827,11092707,18236843,20845239]}"
	if practice==Constants.StartItem.StartStrijkendAanleggen:
	    return "{\"endTime\":30391879,\"practice\":7,\"recording_commands\":[5,0,20,10,1],\"recording_time\":[1060051,13583198,15202473,17221924,21862261]}"
	if practice==Constants.StartItem.StartStrijkendAanleggenWal:
		if GameState.isScull:
		    return "{\"endTime\":26744325,\"practice\":9,\"recording_commands\":[5,0,18,10,1],\"recording_time\":[1658809,10490074,12263792,14622827,19332902]}"
		else:
		    return "{\"endTime\":26744325,\"practice\":9,\"recording_commands\":[5,0,32,10,1],\"recording_time\":[1658809,10490074,12263792,14622827,19332902]}"
	if practice==Constants.StartItem.SlalomPractice:
		return "{\"endTime\":205476266,\"practice\":14,\"recording_commands\":[4,1,2,1,3,1,7,1,3,1,7,1,3,1,6,1,5,1,8,2,0,17,22,2,1,9,1,4,1,6,1,4,1,6,1,4,1,3,1,2,0,17,22,2,1,10,1,3,1,7,1,3,1,7,1,3,1,2,0],\"recording_time\":[1501275,8802006,10179120,14029510,16405376,19912247,21669659,25717064,27071160,30371671,32642665,35702251,37620464,40410455,45092220,46763751,49771996,52338378,54343659,56584510,62886463,64106885,78619945,80879638,84028246,85207267,93331720,96003091,98224682,99871827,103335811,105718730,108343904,110767200,115207040,117939976,119605743,124252726,125462170,128142120,133595929,134869753,151751820,154324905,156905084,159665617,164782260,165995008,171408422,172976799,176502711,178029401,180794748,183951085,186828854,189515123,190798172,193652146,204454519]}"
	if practice==Constants.StartItem.MoringHarbour:
		return "{\"endTime\":56244182,\"practice\":13,\"recording_commands\":[30,0,9,1,6,1,4,1,2,0,20,1],\"recording_time\":[875401,7977137,13557136,21923764,23716607,25790049,27821040,29816913,33953220,36299118,37486814,42123153]}"
	if practice==Constants.StartItem.MoringHarbourBB:
		return "{\"endTime\":79566693,\"practice\":22,\"recording_commands\":[30,0,1,9,1,6,1,5,1,8,25,30,0,21,1],\"recording_time\":[1133285,13062445,15394282,16355098,22644529,23709052,30101484,33651004,37710064,39172456,42269126,43960646,59451581,65201203,71356426]}"
	if practice==Constants.StartItem.Intro:
		return "{\"endTime\":318448363,\"practice\":11,\"recording_commands\":[2,0,3,1,2,28,29,27,29,0,10,1,3,1,3,1,4,1,2,28,29,27,29,27,29,0,10,1,2,1,4,1,2,0,3,1,2,0,3,1,2,0],\"recording_time\":[835107,36722319,39110817,49338655,52059375,85179880,89291502,104625784,107684459,110400243,116169546,123018008,124166614,128093456,132523353,135403680,140538840,141654656,143176203,149077423,151659213,155730999,157933091,162338301,165555823,177755440,180321872,195099806,197720687,209898975,212752875,221883392,223858105,232835151,239608661,249517169,251461273,288164784,290030661,300663554,302729815,314321995]}"
	if practice==Constants.StartItem.BridgePractice:
		return "{\"endTime\":36557132,\"practice\":15,\"recording_commands\":[30,0,17,22,31],\"recording_time\":[850996,13805980,14830692,22589337,23865157]}"
	if practice==Constants.StartItem.SpinTurnPractice:
		return "{\"endTime\":44829700,\"practice\":17,\"recording_commands\":[16,1,2,1,8,1,15,1,2],\"recording_time\":[1151369,7659962,10643040,19104527,20478007,23757451,24982083,31476667,35600020]}"

	return ""
	
func cancelReplay():
	if GameState.isReplaying:
		GameState.isReplaying=false
		if _replayTimer!=null:
			_replayTimer.stop()

func hasDemo(practice : int):
	return getDemo(practice)!=""
	
func replayDemo(practice : int, isBackgroudReplay = false):
	GameState.backgroundReplay=isBackgroudReplay
	var demo=getDemo(practice)
	if demo!="":
		replay(demo)

func _introSignal(visible):
	if visible:
		replayDemo(Constants.StartItem.Intro,true)
	else:
		cancelReplay()
