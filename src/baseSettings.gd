extends Node

var activeBaseSettings : Dictionary ={}
var language=""
var active=false

func loadTestBaseSettins():
	loadBaseSetingsUrlEncoded("%7B%22boatType%22%3A2%2C%22copiedFromSettingId%22%3A%22%22%2C%22copiedTimestamp%22%3A0%2C%22customButtonSet%22%3A%5B%22HalenBB%22%2C%22Bedankt%22%5D%2C%22disabledPractices%22%3A%5B3%2C4%2C17%2C5%2C8%2C16%2C6%2C7%2C9%2C15%2C13%2C14%5D%2C%22disabledPracticesUseDefault%22%3Afalse%2C%22finishedPractices%22%3A%5B8%5D%2C%22highContrast%22%3Afalse%2C%22highScore%22%3A0%2C%22language%22%3A%22nl_NL%22%2C%22practiceExplainTranslations%22%3A%5B%22%22%2C%22Titel%201%5CnVoer%20de%20volgende%20stappen%20uit%20om%20weg%20te%20varen%20en%20de%20boot%20precies%20op%20de%20ster%20stil%20te%20leggen%3A%5Cn%5Cn1%29%20%5Bcolor%3D%2333eab4%5D%5Bu%5DSlagklaar%20maken%20..%20slag%20klaar..%20af%5B%2Fu%5D%5B%2Fcolor%5D%20%3A%20vaar%20recht%20door%20naar%20de%20ster%5Cn2%29%20%5Bcolor%3D%2333eab4%5D%5Bu%5DLaat%20lopen%20volledig%5B%2Fu%5D%5B%2Fcolor%5D%20%E2%80%A6%20%5Bcolor%3D%2333eab4%5D%5Bu%5DBedankt%20volledig%5B%2Fu%5D%5B%2Fcolor%5D%3A%20vlak%20voor%20de%20ster%20%5Cn3%29%20%5Bcolor%3D%2333eab4%5D%5Bu%5DVastroeien%20beide%20boorden%5B%2Fu%5D%5B%2Fcolor%5D%20%3A%20om%20de%20boot%20op%20de%20ster%20stil%20te%20leggen%20%5Cn4%29%20%5Bcolor%3D%2333eab4%5D%5Bu%5DBedankt%20volledig%5B%2Fu%5D%5B%2Fcolor%5D%20het%20laatste%20commando%20te%20be%C3%ABindigen.%5Cn%22%2C%22Titel%202%5CnVoer%20de%20volgende%20stappen%20uit%20om%20weg%20te%20varen%20en%20over%20de%20ster%20aan%20bakboord%20te%20varen.%5Cn%5Cn1%29%20%5Bcolor%3D%2333eab4%5D%5Bu%5DSlagklaar%20maken%20..%20slag%20klaar..%20af%5B%2Fu%5D%5B%2Fcolor%5D%20%3A%20vaar%20recht%20door%20naar%20de%20ster%5Cn2%29%20%5Bcolor%3D%2333eab4%5D%5Bu%5DLaat%20lopen%20volledig%5B%2Fu%5D%5B%2Fcolor%5D%20%E2%80%A6%20%5Bcolor%3D%2333eab4%5D%5Bu%5DBedankt%20volledig%5B%2Fu%5D%5B%2Fcolor%5D%3A%20vlak%20voor%20de%20bocht%20%5Cn3%29%20Gebruik%20eerst%20%5Bcolor%3D%2333eab4%5D%5Bu%5DVastroeien%20BB%5B%2Fu%5D%5B%2Fcolor%5D%20en%20indien%20nodig%20%5Bcolor%3D%2333eab4%5D%5Bu%5DHalen%20SB%5B%2Fu%5D%5B%2Fcolor%5D%20om%20de%20boot%20de%20te%20draaien%20en%20%5Bcolor%3D%2333eab4%5D%5Bu%5DBedankt%20volledig%5B%2Fu%5D%5B%2Fcolor%5D%20om%20draaien%20te%20be%C3%ABindigen%5Cn4%29%20%5Bcolor%3D%2333eab4%5D%5Bu%5DSlagklaar%20maken%20..%20slag%20klaar..%20af%5B%2Fu%5D%5B%2Fcolor%5D%20%3A%20vaar%20recht%20door%20over%20de%20ster%5Cn%22%5D%2C%22practiceTranslations%22%3A%5B%22%22%2C%22Titel%201%22%2C%22Titel%202%22%5D%2C%22ruleset%22%3A%22RulesetNoRules%22%2C%22shortSettingsInUrl%22%3Atrue%2C%22shortcuts%22%3A%7B%22Bedankt%22%3A%22z%22%2C%22LaatLopen%22%3A%22s%22%7D%2C%22showCommandTooltips%22%3Afalse%2C%22showShortCutsInButtons%22%3Afalse%2C%22successCount%22%3A1%2C%22textTranslations%22%3A%7B%22Bedankt%22%3A%22Bedankt%20volledig%22%2C%22LaatLopen%22%3A%22Laat%20lopen%20volledig%22%7D%2C%22tooltips%22%3A%7B%22Bedankt%22%3A%22Knop%20hint%20bedankt%22%2C%22LaatLopen%22%3A%22Knop%20hint%20laat%20lopen%22%7D%2C%22translations%22%3A%7B%22Bedankt%22%3A%22Knop%20%20Bedankt%22%2C%22LaatLopen%22%3A%22Knop%20laat%20lopen%22%7D%2C%22waterAnimation%22%3Afalse%2C%22zoom%22%3A-1%2C%22name%22%3A%22Gedeelde%20set%22%7D%0A")

func loadBaseSetingsUrlEncoded(settingStr):
	loadBaseSetings(settingStr.percent_decode())
	
func loadBaseSetings(settingStr):
	var settings=parse_json(settingStr);
	if settings==null:
		print("Can not parse json")
		return	
	loadBaseSettingsFromDict(settings)
	
func loadBaseSettingsFromDict(settings : Dictionary):
	activeBaseSettings=settings
	language=Utilities.getLanguageFromSettings(settings)
	active=true
	

func loadSharedSetings(settingStr : String,activate=true):
	var decode=parse_json(settingStr);
	if decode==null:
		print("Can not parse json")
		return
	Settings.sharedSettings=decode
	loadedSharedSettings()
	GameEvents.loadedSharedSettings()
	if activate:
		activateSharedSetting()
		Settings.currentLang=Constants.sharedSettingLangKey
		GameEvents.settingsChanged()
		GameEvents.languageChanged()

func activateSharedSetting():
	loadBaseSettingsFromDict(Settings.sharedSettings)
	
func clearBaseSettings():
	activeBaseSettings={};
	language=""
	active=false

# for loading the shard settings into the constants which are loaded into the drop downs
func loadedSharedSettings():
	var indexNr=-1;
	if Settings.sharedSettings!=null && Settings.sharedSettings.keys().size()>0: 
		
		indexNr=Constants.languageKeys.find(Constants.sharedSettingLangKey)
		if indexNr<0:
			Constants.languageKeys.append(Constants.sharedSettingLangKey)
			Constants.urlKeys.append("shared_setting")
			Constants.flags.append("")	
			Constants.languageLongItems.append("")
			Constants.baseConfigs.append("")
			indexNr=Constants.languageKeys.size()-1
		var lang : String=Settings.sharedSettings["language"]
		if lang!=null && lang.begins_with("en"):
			Constants.flags[indexNr]="gb"
		else:
			Constants.flags[indexNr]="nl" #pick a generic flag for a custom set
		var settingsName=""
		if Settings.sharedSettings.has("name"):
			settingsName=Settings.sharedSettings.get("name")
		if settingsName=="" || settingsName==null:
			settingsName="SharedSettings"

		Constants.languageLongItems[indexNr]=settingsName
	return indexNr
#	var customItemIndex=Constants.languageKeys.find(Constants.sharedSettingLangKey)
