extends WindowDialog


var loadSettingId="";
var settingsName="";
var shortSettingsInUrl=true
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

func getAndPrintEncodedSettings():
	var settings=$"%SettingsDialog".getSharedSettings(settingsName)	
	var json=to_json(settings)
	print(json+"\n\n")
	var urlSettings=json.percent_encode()
	print(urlSettings+"\n\n")
	return urlSettings
	
func setSettingInUrl():
	if shortSettingsInUrl:
		var urlSettings=getAndPrintEncodedSettings()
		var url=Constants.serverUrl+"/saveSharedSetting?data="+urlSettings
		$HTTPRequest.request(url, [], true, HTTPClient.METHOD_GET) 
		return false
	else:
		setFullSettingsinUrl()
		

func setFullSettingsinUrl():
	var urlSettings=getAndPrintEncodedSettings()
		
	if sendSettingsToBrowser("&settings="+urlSettings+"'"):
		show_modal(true)
	
func _onLoadSettings(result, response_code, headers, body):
	var text=body.get_string_from_utf8()
	if response_code==200:
		BaseSettings.loadSharedSetings(text,true)
		
func loadSettings(settingsId):
	loadSettingId=settingsId;

	var urlSettings='{"id":"'+settingsId+'"}'
	var url=Constants.serverUrl+"/getSharedSetting?data="+urlSettings
	$HTTPRequestLoad.request(url, [], true, HTTPClient.METHOD_GET) 


	
func sendSettingsToBrowser(urlSettingParam):
	var urlLang=Utilities.getUrlLang()
	var hasShare=JavaScript.eval("typeof navigator.share=='function'");
	var urlScript="window.location.protocol + '//' + window.location.host + window.location.pathname + '?lang="+urlLang+urlSettingParam
	if hasShare:
		JavaScript.eval("navigator.share({url:"+urlScript+"})");
		return false
	else:
		JavaScript.eval("history.pushState({}, null, "+urlScript+")");
		JavaScript.eval("if (typeof navigator.clipboard=='object' && typeof navigator.clipboard.writeText=='function' ) navigator.clipboard.writeText("+urlScript+");")
	return true
	
func start(name : String,p_shortSettingsInUrl : bool):
	settingsName=name
	shortSettingsInUrl=p_shortSettingsInUrl
	setSettingInUrl()

func _on_CloseDialog_pressed():
	Utilities.resetUrlPameters()
	hide()
