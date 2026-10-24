extends Button

# speech recognition of commands, implemented in speechRecognition.js (bin/html)

# include in export header
# <script type='text/javascript' src='speechRecognition.js'></script>

var speakCallBack = JavaScript.create_callback(self, "spoken") # This reference must be kept

# seconds between commands spoken in one sentence, like "laat lopen bedankt"
var commandDelay=0.5

# rings rippling around the button while listening
var listeningRings : ColorRect
var ringScale=2.4
# grayish red of the button and the rings while listening
var listeningColor=Color(0.6,0.3,0.3)
var listeningHoverColor=Color(0.7,0.4,0.4)

func _ready() -> void:
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	if GameState.mobileMode:
		rect_position.y=2
		margin_top=20
		anchor_top=0
		margin_left-=20
		margin_right-=20
		rect_size.x+=16
		rect_size.y+=28;
		# move the text to the left (like replayCommandText), so it is not behind the buttons
		$"%speakCommandText".add_font_override("font",load("res://FontExtraLarge.tres"))
		$"%speakCommandText".anchor_left=0.1

	createListeningRings()
	saveNormalLayout()
	if !Utilities.speechRecognitionSupported():
		setVisible(false)

# anchors and margins of the normal position, used to undo the centering
var normalLayout=[]

func saveNormalLayout():
	normalLayout=[anchor_left,anchor_top,anchor_right,anchor_bottom,margin_left,margin_top,margin_right,margin_bottom]

# distance to the right border in mobile mode when the command buttons are hidden
var mobileCenteredRightOffset=50
# distance to the bottom border in desktop mode when the command buttons are hidden
var centeredBottomOffset=25
# scale of the button when the command buttons are hidden
var centeredScale=1.5
var mobileCenteredScale=2.0

# centered when the command buttons are hidden: horizontally, in mobile mode vertically
func setCentered(on : bool):
	if normalLayout.empty():
		saveNormalLayout()
	anchor_left=normalLayout[0]
	anchor_top=normalLayout[1]
	anchor_right=normalLayout[2]
	anchor_bottom=normalLayout[3]
	margin_left=normalLayout[4]
	margin_top=normalLayout[5]
	margin_right=normalLayout[6]
	margin_bottom=normalLayout[7]
	rect_scale=Vector2(1,1)
	if GameState.mobileMode:
		# without buttons the text can be centered
		$"%speakCommandText".anchor_left=0.5 if on else 0.1
	if !on:
		return
	var size=rect_size
	# bigger button, scaled around its center
	rect_pivot_offset=size/2
	var scale=mobileCenteredScale if GameState.mobileMode else centeredScale
	rect_scale=Vector2(scale,scale)
	# the extra half size, to keep the same distance to the border
	var scaledExtra=size*(scale-1)/2
	if GameState.mobileMode:
		anchor_top=0.5
		anchor_bottom=0.5
		margin_top=-size.y/2
		margin_bottom=size.y/2
		margin_right=-mobileCenteredRightOffset-scaledExtra.x
		margin_left=-mobileCenteredRightOffset-scaledExtra.x-size.x
	else:
		anchor_left=0.5
		anchor_right=0.5
		margin_left=-size.x/2
		margin_right=size.x/2
		anchor_top=1.0
		anchor_bottom=1.0
		margin_bottom=-centeredBottomOffset-scaledExtra.y
		margin_top=-centeredBottomOffset-scaledExtra.y-size.y

func createListeningRings():
	listeningRings=ColorRect.new()
	var ringMaterial=ShaderMaterial.new()
	ringMaterial.shader=load("res://SpeakListening.gdshader")
	listeningRings.material=ringMaterial
	listeningRings.show_behind_parent=true
	listeningRings.mouse_filter=Control.MOUSE_FILTER_IGNORE
	listeningRings.visible=false
	add_child(listeningRings)

func setListening(on : bool):
	if on:
		var ringSize=max(rect_size.x,rect_size.y)*ringScale
		listeningRings.rect_size=Vector2(ringSize,ringSize)
		listeningRings.rect_position=(rect_size-listeningRings.rect_size)/2
		var ringColor=Color.white if Settings.highContrast else listeningColor
		listeningRings.material.set_shader_param("ring_color",ringColor)
	listeningRings.visible=on
	setListeningStyle(on)

# red background while listening, keeping the transparency of the normal style
func setListeningStyle(on : bool):
	if !on:
		setStyleButtons()
		return
	for styleName in ["normal","hover","focus","pressed"]:
		var style=get_stylebox(styleName)
		if style is StyleBoxFlat:
			style=style.duplicate()
			var red=listeningColor if styleName=="normal" else listeningHoverColor
			red.a=style.bg_color.a
			style.bg_color=red
			add_stylebox_override(styleName,style)

func setVisible(show : bool):
	show=show && Utilities.speechRecognitionSupported()
	visible=show
	if !show && listeningRings.visible:
		setListening(false)
		if OS.has_feature('JavaScript'):
			JavaScript.get_interface("speachInterface").stopListening()
	$"%speakCommandText".visible=show

func _pressed():
	if !OS.has_feature('JavaScript'):
		return
	setText("",false)
	var speak = JavaScript.get_interface("speachInterface")
	if listeningRings.visible:
		# pressed again while listening: stop
		setListening(false)
		speak.stopListening()
		return
	if !Settings.speechWarningShown:
		# first time: explain the experimental feature
		Settings.speechWarningShown=true
		$"%SettingsDialog".saveSettings()
		# remember full screen before the browser asks the microphone permission (which can leave full screen)
		var wasFullScreen=JavaScript.eval("typeof fullScreenActive=='function' && fullScreenActive()")==true
		$"%SpeechWarningDialog".start(wasFullScreen)
		if !GameState.isAndroid:
			# listening starts when the dialog is closed (SpeechWarningDialog calls startListeningIfStopped)
			return
		# android: listening starts directly at the same time, the microphone permission is asked from the click
	startListening()

func startListening():
	var speak = JavaScript.get_interface("speachInterface")
	speak.setCommands(to_json(getCommandTexts()), $"%SpeakCommand".getSpeachCultureCode())
	setListening(true)
	speak.waitForCommand(speakCallBack)

# start listening again when it has stopped (for example while the info dialog was open)
func startListeningIfStopped():
	if visible && !listeningRings.visible:
		setText("",false)
		startListening()

func setStyleButtons():
	Styles.SetRoundedButtonStyle(self)

func _highContrastChangedSignal(highContrast):
	setStyleButtons();

# all texts which can be spoken for a command: the full command text and the button text
func getCommandTexts():
	var result=[]
	var commands=Constants.commandNames
	for i in range(0,commands.size()):
		var commandName=commands[i]
		var command=Utilities.commandNameToCommand(commandName)
		addCommandText(result,command,commandName,Utilities.getFullCommand(command))
		addCommandText(result,command,commandName,tr(Utilities.calcButtonTextFromCommand(commandName,command)))
	return result

func addCommandText(result,command,commandName,text):
	text=Utilities.removeTagsFromText(text).strip_edges()
	if text!="":
		result.append({"nr":command,"text":text})

# seconds a recognised command or error stays visible
var commandTextTime=3
var _commandTextTimer=null

func setText(text : String, isError : bool, markError=true):
	# a new text cancels the removal of the previous command
	if _commandTextTimer!=null:
		Utilities.removeTimer(_commandTextTimer)
		_commandTextTimer=null
	if isError && markError:
		text="? "+ text +" ?"
	var label=$"%speakCommandText"
	label.text=text;
	label.add_color_override("font_color",Color.red if isError else Color.white)
	if text!="":
		_commandTextTimer=Utilities.startTimer(commandTextTime)
		yield(_commandTextTimer, "timeout")
		Utilities.removeTimer(_commandTextTimer)
		_commandTextTimer=null
		label.text=""

# execute a spoken command the same way as pressing a command button (GridButtonContainer.execCommand):
# in step by step mode check the command, otherwise only when playing
func execCommand(command : int):
	if GameState.isPaused && GameState.replayStepByStep:
		GameState.commandCount=GameState.commandCount+1
		GameEvents.doCheckCommand(command)
	elif !GameState.isReplaying && !GameState.isPaused:
		GameState.commandCount=GameState.commandCount+1
		GameEvents.doCommand(command)

func spoken(args):
	# args: [JSON array of command numbers, heard text, matched command texts]
	print(args)
	if !listeningRings.visible:
		# listening was stopped by the user
		return
	setListening(false)
	var commands=parse_json(str(args[0]))
	if commands is Array && commands.size()>0:
		setText(str(args[2]),false)
		for i in range(0,commands.size()):
			if i>0:
				yield(get_tree().create_timer(commandDelay),"timeout")
			execCommand(int(commands[i]))
	elif args.size()>3 && str(args[3])!="":
		# translation key with a message for the error
		setText(tr(str(args[3])),true,false)
	else:
		setText( str(args[1]),true)
