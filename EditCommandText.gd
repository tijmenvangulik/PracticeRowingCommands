extends MarginContainer

signal customCommandTextChanged(command,commandName,value)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var command =0
var commandName= ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func sendCommandChanged(command,commandName,value):
	emit_signal("customCommandTextChanged",command,commandName,value)

func sendTextChangedMessage(textValue):
	var mainItem=$"/root/World/CanvasLayer/SettingsDialog/EditCommandText"#World/CanvasLayer/SettingsDialog/EditCommandText
	mainItem.sendCommandChanged(command,commandName,textValue)
	
func setText(text):
	$"LineEdit".text=text
	sendTextChangedMessage(text)
	
func _on_LineEdit_text_changed(new_text):
	var textValue=$ "LineEdit".text;
	if (textValue==""): 
		textValue=commandName
	sendTextChangedMessage(textValue)
