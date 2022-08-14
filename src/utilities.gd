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
		while secStr.length()<3:
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
