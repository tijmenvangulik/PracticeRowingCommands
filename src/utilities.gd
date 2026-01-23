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

func calcOriginalTooltipText(command,commandName):
	var tooltip=Utilities.getCommandTooltip(command)
	if tooltip!="" && tooltip!=null:
		return tooltip
	var shotTooltipKey=commandName+"_shorttooltip"
	tooltip=tr(shotTooltipKey)
	if tooltip==shotTooltipKey:
		return ""
	return tooltip
	
func getCommandShortcut(command:int)->String:
	var result=""
	if command>=0 && command<Settings.shortcutTranslations.size():
		result=Settings.shortcutTranslations[command]
	if result!="":return result
	return getDefaultDictonaryValueSetting("ShortcutTranslations",Constants.commandNames[command])

func calcShortCut(command:int,commandName : String, buttonText : String)->String:
	var shortcut=""
	var customShortcut=getCommandShortcut(command)
	if customShortcut!="":
		shortcut=customShortcut
	else:
		var shortresourceName=commandName+"_shortcut"
		shortcut=tr(shortresourceName)
		if shortcut=="" || shortcut==shortresourceName :
			shortcut=tr(buttonText).substr(0,1).to_lower()
	return shortcut
	
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

func calcButtonTextFromCommand(commandName,command):
	var result=""
	var altButtonCommandName=commandName+"_buttonOnly";
	var buttonResource=tr(altButtonCommandName)
	if buttonResource  && buttonResource!="-" && buttonResource!="" && buttonResource!=altButtonCommandName:
		result=buttonResource
	else:
		result=commandName
	var alterNativeText=Utilities.getCommandTranslation(command)
	if alterNativeText && alterNativeText!="":
		result=alterNativeText
	return result

func calcCommandGridLabelText(commandName):
	var commandLabelText=getDefaultDictonaryValueSetting("CommandTextTranslations",commandName)
	if commandLabelText=="":
		commandLabelText=commandName
	return commandLabelText
	
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
			if GameState.mobileMode && settings.has("customButtonSetMobile"):
				var mobileSettings=settings.get("customButtonSetMobile")
				if mobileSettings!=null && mobileSettings.size()>0:
					result=mobileSettings
		"ButtonSetMobile":
			if settings.has("customButtonSetMobile"):
				var mobileSettings=settings.get("customButtonSetMobile")
				if mobileSettings!=null && mobileSettings.size()>0:
					result=mobileSettings
	
	if result==null || result.size()==0:
		var resultStr=tr(name)
		if resultStr!=name && resultStr!=null && resultStr!="":
			result=JSON.parse(resultStr).result
	return result

func mergeSettingsValue(name : String,emptyValue ,settings : Dictionary,sharedSettings : Dictionary ):
	var value=emptyValue
	if sharedSettings!=null && sharedSettings.has(name):
		value=sharedSettings[name]
	if settings!=null && settings.has(name):
		var valOverride=settings[name]
		if  typeof(valOverride)==TYPE_ARRAY:
			if valOverride!=emptyValue && valOverride.size()>0:
				value=valOverride
		elif  typeof(valOverride)==TYPE_STRING:
			if valOverride!=emptyValue && valOverride.length()>0:
				value=valOverride
		elif valOverride!=emptyValue :
			value=valOverride
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

var closeIconTexture=load("res://assets/starPractice.png")

func modifyCloseButton(dlg : WindowDialog):
	if GameState.mobileMode:
		var button : TextureButton=dlg.get_close_button()
		button.margin_left=-40
		button.rect_scale.x=2
		button.rect_scale.y=2


func MobileScrollConainerSpaceBottom(scroll : ScrollContainer):
	var h_scroll = scroll.get_h_scrollbar()
	h_scroll.rect_min_size.y = 30
	
func MobileScrollConainerSpaceRight(scroll : ScrollContainer):
	var h_scroll = scroll.get_v_scrollbar()
	h_scroll.rect_min_size.x = 30
	
func MobileScrollConainer(scroll : ScrollContainer):
	
	
#	pass
	
	#var h_scroll = scroll.get_h_scrollbar()
	#var scrollbar_thickness = 50
	#var theme = Theme.new()
	#var style = StyleBoxFlat.new()
#	style.set_default_margin(MARGIN_LEFT, scrollbar_thickness / 2)
	#style.set_default_margin(MARGIN_RIGHT, scrollbar_thickness / 2)
	#h_scroll.add_stylebox_override("scroll", style)

	
	var h_scroll = scroll.get_h_scrollbar()
	
	var v_scroll = scroll.get_v_scrollbar()
	v_scroll.rect_min_size.x = 30
	h_scroll.rect_min_size.y = 30
	h_scroll.set_scale(Vector2(1,-1))
	v_scroll.set_scale(Vector2(-1,1))
	v_scroll.margin_left=0
	h_scroll.margin_top=0
	
    # Option 1: Create and assign a new StyleBox with custom margin
	#var style = StyleBoxFlat.new()
	#style.content_margin_left=40
	#style.content_margin_right=40
	#style.border_width_right=30
	#style.border_width_bottom=30
	
	#style.bg_color = Color(0.6, 0.6, 0.6) # optional: set color
	#style.set_default_margin(Margin.LEFT, 0)
	#style.set_default_margin(Margin.TOP, 0)
	#style.set_default_margin(Margin.RIGHT, 0)
	#style.set_default_margin(Margin.BOTTOM, 0)

    # Set the min size (this controls the scrollbar thickness)
	#h_scroll.rect_min_size.y=50 # height for horizontal
	#v_scroll.rect_min_size.x=50 # width for vertical

    # Apply the style (optional, but ensures it's visible)
	#h_scroll.add_stylebox_override("grabber", style)
	#v_scroll.add_stylebox_override("grabber", style)
	
	#style = StyleBoxFlat.new()
	#style.content_margin_right=50
	#style.content_margin_bottom=50
	
	#h_scroll.add_stylebox_override("scroll", style)
	#v_scroll.add_stylebox_override("scroll", style)

func scrollToGridItem(item,scrollContainer,grid):
	var item_y = item.rect_position.y
	var item_h = item.rect_size.y
	var view_h = scrollContainer.rect_size.y
	var content_h = grid.rect_size.y
	var target = item_y - (view_h - item_h) / 2
	var max_scroll = max(0, content_h - view_h)
	scrollContainer.scroll_vertical = clamp(target, 0, max_scroll)

func getUrlLang():
	var urlLang=""
	var lang=Settings.currentLang
	if lang==Languages.sharedSettingLangKey:
		urlLang=lang
	else:
		var indexNr=Languages.languageKeys.find(lang)
		if indexNr>=0:
			urlLang=Languages.urlKeys[indexNr]
	return urlLang;

func resetUrlPameters():
	var urlLang=Utilities.getUrlLang()
	JavaScript.eval("history.pushState({}, null, window.location.protocol + '//' + window.location.host + window.location.pathname+'?lang="+urlLang+"' )");

func arrays_have_same_content(array1, array2):
	if array1.size() != array2.size(): return false
	for item in array1:
		if !array2.has(item): return false
		if array1.count(item) != array2.count(item): return false
	return true
