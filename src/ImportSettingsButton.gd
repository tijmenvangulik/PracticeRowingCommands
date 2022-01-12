extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var importCallBack = JavaScript.create_callback(self, "settingsLoaded") # This reference must be kept

func _ready():
	var importScript="window.importObject={clickElem:function (elem) {" \
+"	var eventMouse = document.createEvent('MouseEvents');" \
+"	eventMouse.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);" \
+"	elem.dispatchEvent(eventMouse);" \
+"}" \
+",openFile:function (func) {" \
+"	var readFile = function(e) {" \
+"		var file = e.target.files[0];" \
+"		if (!file) {" \
+"			return;" \
+"		}" \
+"		var reader = new FileReader();" \
+"		reader.onload = function(e) {" \
+"			var contents = e.target.result;" \
+"			fileInput.func(contents);" \
+"			document.body.removeChild(fileInput);" \
+"		};" \
+"		reader.readAsText(file);" \
+"	};" \
+"	fileInput = document.createElement('input');" \
+"	fileInput.type='file';" \
+"	fileInput.style.display='none';" \
+"	fileInput.onchange=readFile;" \
+"	fileInput.func=func;" \
+"	document.body.appendChild(fileInput);" \
+"	window.importObject.clickElem(fileInput);" \
+"}" \
+"}" 
	JavaScript.eval(importScript);

func _pressed():	
	var import = JavaScript.get_interface("importObject")
	if import!=null:
		import.openFile(importCallBack)
#	testImport()

func doImport(settings):
	settings.erase("highScore")
	$"..".setSettings(settings)
	GameEvents.settingsChanged()
	GameEvents.customButtonSetChanged()

#func testImport():
#	var settings = parse_json("{\"customButtonSet\":[\"HalenBeideBoorden\",\"LaatLopen,Bedankt\",\"VastroeienSB\",\"HalenSB\",\"StrijkenSB\",\"StrijkenBeidenBoorden\",\"VastroeienBeideBoorden\",\"VastroeienBB\",\"HalenBB\",\"StrijkenBB\",\"Slippen\",\"SlippenSB\",\"UitbrengenSB\",\"PeddelendStrijkenSB\",\"StuurboordBest\",\"Uitbrengen\",\"SlippenBB\",\"UitbrengenBB\",\"PeddelendStrijkenBB\",\"BakboortBest\",\"LightPaddle\",\"LightPaddleBedankt\",\"RiemenHoogSB\",\"RiemenHoogBB\",\"BestBedankt\"],\"ruleset\":\"RulesetNoRules\",\"translations\":{\"Bedankt\":\"Bedankt2\"}}")
#	doImport(settings)

func settingsLoaded(params):
	var settings = parse_json(params[0])
	doImport(settings)
