extends MarginContainer

var command =0
var commandName= ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setText(text):
	$"LineEdit".text=text
	GameEvents.sendShortcutChanged(command,commandName,text)

func _on_LineEdit_text_changed(new_text):
	var textValue=$ "LineEdit".text.to_lower();
	GameEvents.sendShortcutChanged(command,commandName,textValue)
	
