extends MarginContainer

var command =0
var commandName= ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setText(text):
	$"LineEdit".text=text
	GameEvents.sendCommandChanged(command,commandName,text)

func _on_LineEdit_text_changed(new_text):
	var textValue=$ "LineEdit".text;
	if (textValue==""): 
		textValue=commandName
	GameEvents.sendCommandChanged(command,commandName,textValue)
	
