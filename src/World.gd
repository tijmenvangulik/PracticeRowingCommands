extends Node2D




var _callback = JavaScript.create_callback(self, "receivedMessage")

func _ready():
	subToMessages()

func subToMessages():
	if OS.has_feature('JavaScript'):
		var window = JavaScript.get_interface("window")
		window.onmessage = _callback
		
func receivedMessage(args):
	# parse
	var key
	if args[0].message:
		key = 'message'
	else:
		key = 'data'
	var data = args[0][key]
	
	# filter
	if data.find('toGodot:') == 0:
		# message starts with 'toGodot:'
		data = data.replace('toGodot:', '')
		
		# emit or whatever you wanna do with this data
		GameEvents.sendJavascriptMessage(data)
