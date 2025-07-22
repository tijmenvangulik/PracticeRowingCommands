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
	
func showOnlyButtons(var commands : Array):
	var commandToSend=[]
	for command in commands:
		commandToSend.append(Constants.commandNames[command])
	GameState.enabledCommands=commandToSend
	
	GameEvents.commandsChanged(commands)

func styleDropDown(dropdown):
	if GameState.mobileMode:
		dropdown.get_popup().add_constant_override("vseparation",20)
	else:
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

var	maskImage : StreamTexture=preload( "res://assets/flags/nl_mask.png")
var flag_nl : StreamTexture=preload("res://assets/flags/nl.svg")
var flag_gb : StreamTexture=preload("res://assets/flags/gb.svg")

func getColoredBlade(color : Color,flag : String) -> Texture:
	var image : Image = maskImage.get_data()
	var width=image.get_width()
	var height=image.get_height()
	replace_color_in_texture(image,Color("#000000"), color)
	image.resize(width*0.7,height*0.7)
	
	var flagImageStream : StreamTexture= flag_nl;
	if flag=="gb":
		flagImageStream=flag_gb;
	var imageFlag : Image = flagImageStream.get_data()
	var widthFlag=imageFlag.get_width()
	var heightFlag=imageFlag.get_height()
	image.blend_rect(imageFlag, Rect2(0,0,imageFlag.get_width(),imageFlag.get_height()), Vector2(0,0))
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture
	
func replace_color_in_texture(image, from_color: Color, to_color: Color):
	
	image.lock()  # Je moet de image locken voor bewerken

	for y in image.get_height():
		for x in image.get_width():
			var color = image.get_pixel(x, y)
			if color.r == from_color.r and color.g == from_color.g and color.b == from_color.b:
				# vervang alleen RGB, behoud alpha
				image.set_pixel(x, y, Color(to_color.r, to_color.g, to_color.b, color.a))

	image.unlock()


func languageToFlag(lang : String) -> String:
	if lang!=null && lang.begins_with("en"):
		return "gb"
	return "nl"
