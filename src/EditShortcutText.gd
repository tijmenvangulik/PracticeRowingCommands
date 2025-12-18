extends MarginContainer

var command =0
var commandName= ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setText(text):
	$"LineEdit".text=text
	GameEvents.sendShortcutChanged(command,commandName,text)
	recalcOrignalText()

func _on_LineEdit_text_changed(new_text):
	var textValue=$ "LineEdit".text.to_lower();
	GameEvents.sendShortcutChanged(command,commandName,textValue)
	recalcOrignalText()
	
func recalcOrignalText():
	if $"LineEdit".text=="":
		var buttonText=Utilities.calcButtonTextFromCommand(commandName,command)
		var shortCut=Utilities.calcShortCut(command,commandName,buttonText)
		$LineEdit/OriginalText.text=shortCut
	else:
		$LineEdit/OriginalText.text=""


func _on_LineEdit_gui_input(event: InputEvent) -> void:
	recalcOrignalText()
