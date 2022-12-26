extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lang=""

func handleShow():
	if visible:
		$"HSplitContainer/CloseButton".grab_focus()
	
func _init():
	connect("visibility_changed",self,"handleShow");
	
# Called when the node enters the scene tree for the first time.
func _ready():
	setText()
	get_close_button().hide()
	GameEvents.connect("introSignal",self,"_introSignal")
	
func setText():
	var intro=$"IntroText"
	intro.set_bbcode(tr("IntroText"))
	var links=$"Links"
	links.set_bbcode(tr("Links"))
	lang=TranslationServer.get_locale()

func _process(delta):
	if lang!=TranslationServer.get_locale():
		setText()
		
func _introSignal(isVisible : bool):
	visible=isVisible
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
