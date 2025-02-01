extends HTTPRequest



	
# anonymous loging some usage info
# log when a practice is finished with success or failed
func logFinishedActivity(name : String, success : bool,isScull : bool):
	
	var url=Constants.serverUrl+"/logFinishedActivity"
	#var url="http://localhost:2024/logFinishedActivity"
	url=url+"?data[name]="+name.percent_encode()
	url=url+"&data[language]="+Settings.currentLang
	url=url+"&data[success]="+Utilities.boolToSting(success)
	url=url+"&data[isScull]="+Utilities.boolToSting(isScull)
	$"%LogActivityRequest".request(url, [], true, HTTPClient.METHOD_GET)
	
