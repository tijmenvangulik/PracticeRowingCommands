extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#func _ready():
#	JavaScript.eval(safeFunc,true);
	
# Called when the node enters the scene tree for the first time.
func _pressed():
	var safeFunc="var saveData = (function () {" \
	+"    var a = document.createElement('a');"\
	+"    document.body.appendChild(a);"\
	+"    a.style = 'display: none';"\
	+"    return function (json, fileName) {"\
	+"        var blob = new Blob([json], {type: 'octet/stream'}),"\
	+"            url = window.URL.createObjectURL(blob);"\
	+"        a.href = url;"\
	+"        a.download = fileName;"\
	+"        a.click();"\
	+"        window.URL.revokeObjectURL(url);"\
	+"    };"\
	+"}());"
	$"..".saveSettings()
	var settings=$"..".getSettings()
	settings.erase("highScore")
	var settingsString=to_json(settings)
	JavaScript.eval(safeFunc+"saveData('"+settingsString+"','settings.json')",true)
