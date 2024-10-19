extends WindowDialog


func setSettingInUrl():
	var urlLang=""
	var lang=Settings.currentLang
	var indexNr=Constants.languageKeys.find(lang)
	if indexNr>=0:
		urlLang=Constants.urlKeys[indexNr]
	var settings=$"%SettingsDialog".getSettings(true)
	var urlSettings= to_json(settings).percent_encode()
	JavaScript.eval("history.pushState({}, null, window.location.protocol + '//' + window.location.host + window.location.pathname + '?lang="+urlLang+"&settings="+urlSettings+"')");

func start():
	setSettingInUrl()
	show_modal(true)


func _on_CloseDialog_pressed():
	$"%SettingsDialog".clearSettingsInUrl()
	hide()
