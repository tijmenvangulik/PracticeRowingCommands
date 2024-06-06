extends Node

func commandNameToCommand(commandName : String)->int:
	var result=Constants.commandNames.find(commandName)
	return result
	
func commandIsUsed(commandName : String)->bool:
	var found=false

	for item in GameState.currentButtonSet:
		if item==commandName || item.begins_with(commandName+",") || item.find(","+commandName)>0:
			found=true
			break
			
	return found
	
func getCommandTranslation(command:int)->String:
	if command>=0 && command<Settings.commandTranslations.size():
		return Settings.commandTranslations[command]
	return ""
	
func getCommandTextTranslation(command:int)->String:
	if command>=0 && command<Settings.commandTextTranslations.size():
		return Settings.commandTextTranslations[command]
	return ""
	
func getCommandTooltip(command:int)->String:
	if command>=0 && command<Settings.tooltipTranslations.size():
		return Settings.tooltipTranslations[command]
	return ""
	
func getCommandShortcut(command:int)->String:
	if command>=0 && command<Settings.shortcutTranslations.size():
		return Settings.shortcutTranslations[command]
	return ""
	
func replaceCommandText(commandText :String) ->String:
	var command=commandNameToCommand(commandText)
	if command>=0:
		var translation=getCommandTextTranslation(command)
		if  translation!=null && translation.length()>0 :
			return translation
	return tr(commandText)
	
func replaceCommandsInText(text:String,decorate=false ) ->String:
	var lastPos=0
	while lastPos>=0:
		lastPos=text.find("{",lastPos);
		if lastPos>=0:
			var posEnd=text.find("}",lastPos);
			if posEnd>0:
				var commandText=text.substr(lastPos+1,posEnd-lastPos-1)
				commandText=replaceCommandText(commandText)
				if decorate:
					commandText="[color=#33eab4][u]"+commandText+"[/u][/color]"
				text=text.substr(0,lastPos)+commandText+text.substr(posEnd+1,text.length())
	return text
	
func formatTime(minutes,seconds,miliSeconds):
	var minStr=String(minutes)
	if minStr.length()==1:
		minStr="0"+minStr
	var secStr=String(seconds)
	if secStr.length()==1:
		secStr="0"+secStr
	var miliSecStr=""
	if miliSeconds>=0:
		miliSecStr=String(miliSeconds)
		while miliSecStr.length()<3:
			miliSecStr="0"+miliSecStr
		miliSecStr="."+miliSecStr
	return minStr+":"+secStr+miliSecStr

func extractTimeParts(time,includeMiliSeconds):
	var seconds = int( fmod(time, 60))
	var minutes = int( time / 60)
	var miliSeconds=-1
	if includeMiliSeconds:
		miliSeconds=int(fmod(time*1000,1000))
	return [minutes,seconds,miliSeconds]
	
func formatScore(time,includeMiliSeconds):
	var timeParts=extractTimeParts(time,includeMiliSeconds)
	var minutes = timeParts[0]
	var seconds =  timeParts[1]
	var miliSeconds=timeParts[2]
	return formatTime(minutes,seconds,miliSeconds)

func disableCommand(name:String,disabled:bool):
	#"../ButtonsContainer/GridContainer/HalenBeideBoorden"
	#var itemNr=grid.find(name)
	GameEvents.disableCommand(name,disabled)
	
func showOnlyButtons(var commands):
	
	for commandName in Constants.commandNames:
		disableCommand(commandName,len(commands)!=0)
	
	for command in commands:
		disableCommand(Constants.commandNames[command],false)
	GameEvents.commandsChanged(commands)

func styleDropDown(dropdown):
	dropdown.get_popup().add_constant_override("vseparation",10)
	
