extends HTTPRequest


# anonymous loging some usage info
# log when a practice is finished with success or failed
func logFinishedActivity(name : String, success : bool):
	
	var url="https://ergometer-space.org/manager/logFinishedActivity"
	#var url="http://localhost:2024/logFinishedActivity"
	url=url+"?data[name]="+name.percent_encode()
	url=url+"&data[language]="+Settings.currentLang
	var successStr="false"
	if success:
		successStr="true"	
	url=url+"&data[success]="+successStr
	$"%LogActivityRequest".request(url, [], true, HTTPClient.METHOD_GET)
	
