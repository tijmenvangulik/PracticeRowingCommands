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
	var result=""
	if command>=0 && command<Settings.commandTranslations.size():
		result= Settings.commandTranslations[command]
	if result!="":return result
	return getDefaultDictonaryValueSetting("CommandTranslations",Constants.commandNames[command])

	
func getCommandTextTranslation(command:int)->String:
	var result=""
	if command>=0 && command<Settings.commandTextTranslations.size():
		result= Settings.commandTextTranslations[command]
	if result!="":return result	
	return getDefaultDictonaryValueSetting("CommandTextTranslations",Constants.commandNames[command])
	
func getCommandTooltip(command:int)->String:
	var result=""
	if command>=0 && command<Settings.tooltipTranslations.size():
		result=Settings.tooltipTranslations[command]
	if result!="":return result
		
	return getDefaultDictonaryValueSetting("TooltipTranslations",Constants.commandNames[command])
	
func getCommandShortcut(command:int)->String:
	var result=""
	if command>=0 && command<Settings.shortcutTranslations.size():
		result=Settings.shortcutTranslations[command]
	if result!="":return result
	return getDefaultDictonaryValueSetting("ShortcutTranslations",Constants.commandNames[command])

func replaceCommandText(commandText :String) ->String:
	var command=commandNameToCommand(commandText)
	if command>=0:
		var translation=getCommandTextTranslation(command)
		if  translation!=null && translation.length()>0 :
			return translation
	return tr(commandText)
	
func replaceCommandsInText(text:String,decorate=false) ->String:
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
	var font= preload("res://Font.tres")
	dropdown.get_popup().add_font_override("font",font)
	
func startTimer(time):
	var t = Timer.new()
	t.set_wait_time(time)
	t.set_one_shot(true)
	add_child(t)
	t.start()
	return t
	
func removeTimer(t):
	remove_child(t)
	t.queue_free()

func boolToSting(value : bool):
	if value: return "true"
	return "false"

func getDefaultArrayValueSetting(name : String, index : int) -> String:
	var array=[]
	var settings=BaseSettings.activeBaseSettings
	match name:
		"PracticeTranslations": 
			if settings.has("practiceTranslations"):
				array=settings.get("practiceTranslations")
		"PracticeExplainTranslations":
			if settings.has("practiceExplainTranslations"):
				array=settings.get("practiceExplainTranslations")
	if array!=null && index>=0 && typeof(array)==TYPE_ARRAY && index<array.size():
		var result= array[index]
		if result==null:
			return ""
		return result
	return "";

func getDefaultDictonaryValueSetting(name : String, key : String) -> String:
	var dictonary={}
	var settings=BaseSettings.activeBaseSettings
	match name:
		"CommandTranslations":
			if settings.has("translations"):
				dictonary=settings.get("translations")
		"CommandTextTranslations":
			if settings.has("textTranslations"):
				dictonary=settings.get("textTranslations")
		"TooltipTranslations":
			if settings.has("tooltips"):
				dictonary=settings.get("tooltips")
		"ShortcutTranslations":
			if settings.has("shortcuts"):
				dictonary=settings.get("shortcuts")
	if dictonary!=null && dictonary.has(key):
		var result= dictonary.get(key)
		if result==null:
			return ""
		return result;
	return "";
	
func getDefaultSetting(name : String):
	var result="";
	var parseJson=false;
	var settings=BaseSettings.activeBaseSettings
	match name:
		"DefaultBoatType":
			if settings.has("boatType"):
				result=settings.get("boatType")
				if result==2: 
					result="Sweep"
				else:
					result="Scull"
# do not do the ruleset
#		"LanguageRuleSet":
#			if settings.has("ruleset"):
#				result=settings.get("ruleset")
	
	if result=="" || result==null:
		result=tr(name)
		if result==name || result==null:
			result=""
	return result
	
func getDefaultJsonSetting(name : String):
	var result=null;
	var settings=BaseSettings.activeBaseSettings
	match name:
		"DisabledPractices":
			if settings.has("disabledPractices") && settings.has("disabledPracticesUseDefault"):
				if !settings.get("disabledPracticesUseDefault"):
					result=settings.get("disabledPractices")
		"ButtonSet":
			if  settings.has("customButtonSet"):
				result=settings.get("customButtonSet")
				
	
	if result==null || result.size()==0:
		var resultStr=tr(name)
		if resultStr!=name && resultStr!=null && resultStr!="":
			result=JSON.parse(resultStr).result
	return result

func mergeSettingsValue(name : String,emptyValue ,settings : Dictionary,sharedSettings : Dictionary ):
	var value=emptyValue
	if sharedSettings!=null && sharedSettings.has(name):
		value=sharedSettings[name]
	if settings!=null && settings.has(name) && settings[name]!=emptyValue:
		value=settings[name]
	return value

func mergeSettingsArray(name : String,emptyValue ,settings : Dictionary,sharedSettings : Dictionary):
	
	var result=null
	if settings.has(name):
		result=settings[name]
	if result!=null:
		result=result.duplicate()
	else: result=[]
	
	var sharedSettingsValue=null
	if sharedSettings.has(name):
		sharedSettingsValue=sharedSettings[name]
	
	if sharedSettingsValue!=null:
		var max_cnt=max(result.size(),sharedSettingsValue.size())
		for i in max_cnt:
			if i<result.size():
				var value=result[i]
				if i<sharedSettingsValue.size() && ( value==emptyValue || value==null):
					var sharedDefault=sharedSettingsValue[i]
					if sharedDefault!=emptyValue && sharedDefault!=null:
						result[i]=sharedDefault
			else:
				result.append(sharedSettingsValue[i])
		
	return result
	
func mergeSettingsDict(name : String,emptyValue ,settings : Dictionary,sharedSettings : Dictionary):
	var result =null
	if sharedSettings!=null && sharedSettings.has(name):
		result=sharedSettings[name]
	if result!=null:
		result=result.duplicate()
	else: result={}
	
	if settings!=null:
		var settingsValue=null
		if settings.has(name):
			settingsValue=settings[name]
		
		if settingsValue!=null:
			result.merge(settingsValue,true)
	return result

func getLanguageFromSettings(settings : Dictionary):
	var result="nl"
	if settings.has("language"):
		result=settings["language"]
	return result
	
