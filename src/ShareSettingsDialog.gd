extends WindowDialog


func setSettingInUrl():
	var urlLang=""
	var lang=Settings.currentLang
	var indexNr=Constants.languageKeys.find(lang)
	if indexNr>=0:
		urlLang=Constants.urlKeys[indexNr]
	var settings=$"%SettingsDialog".getSettings(true)
	var urlSettings= to_json(settings).percent_encode()
	var hasShare=JavaScript.eval("typeof navigator.share=='function'");
	var urlScript="window.location.protocol + '//' + window.location.host + window.location.pathname + '?lang="+urlLang+"&settings="+urlSettings+"'"
	if hasShare:
		JavaScript.eval("navigator.share({url:"+urlScript+"})");
		return false
	else:
		JavaScript.eval("history.pushState({}, null, "+urlScript+")");
		JavaScript.eval("if (typeof navigator.clipboard=='object' && typeof navigator.clipboard.writeText=='function' ) navigator.clipboard.writeText("+urlScript+");")
	return true

func start():
	if setSettingInUrl():
		show_modal(true)


func _on_CloseDialog_pressed():
	$"%SettingsDialog".clearSettingsInUrl()
	hide()
