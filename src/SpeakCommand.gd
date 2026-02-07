extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("do command register")
	GameEvents.connect("doCommandSignal",self,"_doCommandSignal")

func speakCommandsOn():
	if Settings.speakCommands==Constants.SpeakCommandsType.Off:
		return false
	if Settings.speakCommands==Constants.SpeakCommandsType.Default:
		var value=Utilities.getDefaultSetting("SpeakCommandsActive")
		return value=="true"
	return true

func getSpeachCultureCode():
	var language=Utilities.getDefaultSetting("speechCultureCode")
	if Settings.speakCommands==Constants.SpeakCommandsType.IsoCultureCode && Settings.speechCultureCode!="" && Settings.speechCultureCode!=null:
		language=Settings.speechCultureCode
	return language

func _doCommandSignal(commandId : int):
	if speakCommandsOn() :
		var text=Utilities.getFullCommand(commandId)
		var language=getSpeachCultureCode()
		text=text.replace("'","")
		language=language.replace("'","")
		JavaScript.eval("speak('"+text+"','"+language+"')")

