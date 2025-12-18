extends MarginContainer

var command =0
var commandName= ""
var originalText=""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setText(text):
	$"LineEdit".text=text
	if (text==""): 
		text=commandName
	GameEvents.sendCommandText2Changed(command,commandName,text)
	recalcOrignalText()

func _on_LineEdit_text_changed(new_text):
	var textValue=$ "LineEdit".text;
	if (textValue==""): 
		textValue=commandName
	GameEvents.sendCommandText2Changed(command,commandName,textValue)
	recalcOrignalText()
	
func recalcOrignalText():
	if $"LineEdit".text=="":
		$LineEdit/OriginalText.text=originalText
	else:
		$LineEdit/OriginalText.text=""


func _on_LineEdit_gui_input(event: InputEvent) -> void:
	recalcOrignalText()

