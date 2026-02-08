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

func speak(text , language):
	text=text.replace("'","")
	language=language.replace("'","")
#	print("speak "+language+" "+text)
	JavaScript.eval("speak('"+text+"','"+language+"')")
	
func _doCommandSignal(commandId : int):
	if speakCommandsOn() :
		var text=Utilities.getFullCommand(commandId)
		var language=getSpeachCultureCode()
		
		var startPos=text.find("{{")

		while startPos>=0:
			var endPos=text.find("}}",startPos)
			if endPos>startPos:
				var speakText=text.substr(0,startPos)
				if speakText!="":
					speak(speakText,language)
				language=text.substr(startPos+2,endPos-startPos-2)
				text=text.substr(endPos+2,text.length())
			else:
				break
			startPos=text.find("{{",startPos)
		
		if text!="":
			speak(text,language)
