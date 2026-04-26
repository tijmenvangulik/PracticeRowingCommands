extends HTTPRequest



	
# anonymous loging some usage info
# log when a practice is finished with success or failed
func logFinishedActivity(name : String, success : bool,isScull : bool,cancel=false,stepByStep=false):
	var lang=Settings.currentLang
	if lang==Languages.sharedSettingLangKey:
		if Settings.sharedSettings!=null && Settings.sharedSettings.has("name"):
			var settingsName=Settings.sharedSettings.get("name")
			if settingsName!="":
				lang=settingsName
		
	var url=Constants.serverUrl+"/logFinishedActivity"
	#var url="http://localhost:2024/logFinishedActivity"
	url=url+"?data[name]="+name.percent_encode()
	url=url+"&data[language]="+lang.percent_encode()
	url=url+"&data[success]="+Utilities.boolToSting(success)
	url=url+"&data[isScull]="+Utilities.boolToSting(isScull)
	url=url+"&data[isMobile]="+Utilities.boolToSting(GameState.mobileMode)
	url=url+"&data[cancel]="+Utilities.boolToSting(cancel)
	url=url+"&data[stepByStep]="+Utilities.boolToSting(stepByStep)
	
	$"%LogActivityRequest".request(url, [], true, HTTPClient.METHOD_GET)
	
