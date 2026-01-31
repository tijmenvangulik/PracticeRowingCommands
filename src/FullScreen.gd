extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var fullScreenSprite=load("res://assets/fullscreen.png")
var exitFullScreenSprite=load("res://assets/exitfullscreen.png")


func hasFullScreen():
	var result=JavaScript.eval("hasFullScreen()")
	return result==true
	
func fullScreenActive():
	var result=JavaScript.eval("fullScreenActive()")
	return result==true

func fullscreen():
	JavaScript.eval("fullscreen()")

func cancelFullScreen():
	JavaScript.eval("cancelFullScreen()")

func updateButtonState():
	pressed=fullScreenActive()
	updateIcon()

func updateIcon():
	if pressed:
		icon=exitFullScreenSprite
	else:
		icon=fullScreenSprite 

#func _sizeChanged():
#	updateButtonState()

func _javaScriptMessage(data):
	if data=="fullScreenChanged":
		updateButtonState()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hasFullScreen():
		visible=true
		#GameEvents.connect("windowSizeChanged",self,"_sizeChanged");
		GameEvents.connect("javaScriptMessage",self,"_javaScriptMessage")
	updateButtonState()

func _on_FullScreen_toggled(button_pressed: bool) -> void:
	pass


func _on_FullScreen_pressed() -> void:
	if pressed:
		fullscreen()
	else:
		cancelFullScreen()
	updateIcon()
