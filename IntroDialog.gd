extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lang=""

func handleShow():
	if visible:
		$"CloseButton".grab_focus()
	else: $"../OptionCommands".grab_focus()

func _init():
	connect("visibility_changed",self,"handleShow");
# Called when the node enters the scene tree for the first time.
func _ready():
	setText()
	
func setText():
	var intro=$"IntroText"
	intro.set_bbcode(tr("IntroText"))
	var links=$"Links"
	links.set_bbcode(tr("Links"))
	lang=TranslationServer.get_locale()

func _process(delta):
	if lang!=TranslationServer.get_locale():
		setText()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
