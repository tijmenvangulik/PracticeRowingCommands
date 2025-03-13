extends WindowDialog


var loadSettingId="";

func _ready():
	$HTTPRequest.connect("request_completed", self, "_onReadSettingId")
	$HTTPRequestLoad.connect("request_completed", self, "_onLoadSettings")
	
func _onReadSettingId(result, response_code, headers, body):
	var text=body.get_string_from_utf8()
	if response_code==200:
		var json = JSON.parse(text)
		var settingId=json.result.id
		if sendSettingsToBrowser("&settingId="+settingId+"'"):
			show_modal(true)
	else:
		setFullSettingsinUrl()

func setSettingInUrl():
	if Settings.shortSettingsInUrl:
		var settings=$"%SettingsDialog".getSettings(true)	
		var urlSettings=to_json(settings).percent_encode()
		var url=Constants.serverUrl+"/saveSharedSetting?data="+urlSettings
		$HTTPRequest.request(url, [], true, HTTPClient.METHOD_GET) 
		return false
	else:
		setFullSettingsinUrl()
		

func setFullSettingsinUrl():
	var settings=$"%SettingsDialog".getSettings(true)
	var time=Time.get_unix_time_from_system()
	settings["copiedTimestamp"]=time;
	var urlSettings=to_json(settings).percent_encode()
	if sendSettingsToBrowser("&settings="+urlSettings+"'"):
		show_modal(true)
	

func _onLoadSettings(result, response_code, headers, body):
	var text=body.get_string_from_utf8()
	if response_code==200:
		var json = JSON.parse(text)
		if json!=null:
			# when link is re-used do not overwirte again when already used
			# this way the user can re-use the link which is send to hime
			# without lossing his own settings

			if Settings.copiedFromSettingId!=loadSettingId:
				var settings=json.result;
				settings["copiedFromSettingId"]=loadSettingId
				$"%SettingsDialog".setSettingsFromShortSettings(settings)
				
	
func loadSettings(settingsId):
	loadSettingId=settingsId;

	var urlSettings='{"id":"'+settingsId+'"}'
	var url=Constants.serverUrl+"/getSharedSetting?data="+urlSettings
	$HTTPRequestLoad.request(url, [], true, HTTPClient.METHOD_GET) 
	
func sendSettingsToBrowser(urlSettingParam):
	var urlLang=""
	var lang=Settings.currentLang
	var indexNr=Constants.languageKeys.find(lang)
	if indexNr>=0:
		urlLang=Constants.urlKeys[indexNr]
	
	var hasShare=JavaScript.eval("typeof navigator.share=='function'");
	var urlScript="window.location.protocol + '//' + window.location.host + window.location.pathname + '?lang="+urlLang+urlSettingParam
	if hasShare:
		JavaScript.eval("navigator.share({url:"+urlScript+"})");
		return false
	else:
		JavaScript.eval("history.pushState({}, null, "+urlScript+")");
		JavaScript.eval("if (typeof navigator.clipboard=='object' && typeof navigator.clipboard.writeText=='function' ) navigator.clipboard.writeText("+urlScript+");")
	return true
	
func start():
	
	setSettingInUrl()
		


func _on_CloseDialog_pressed():
	$"%SettingsDialog".clearSettingsInUrl()
	hide()
