extends MarginContainer

var command =0
var commandName= ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setText(text):
	$"LineEdit".text=text
	GameEvents.sendTooltipChanged(command,commandName,text)
	recalcOrignalText()

func _on_LineEdit_text_changed(new_text):
	var textValue=$ "LineEdit".text;
	GameEvents.sendTooltipChanged(command,commandName,textValue)
	recalcOrignalText()

func recalcOrignalText():
	if $"LineEdit".text=="":
		$LineEdit/OriginalText.text=Utilities.calcOriginalTooltipText(command,commandName)
	else:
		$LineEdit/OriginalText.text=""


func _on_LineEdit_gui_input(event: InputEvent) -> void:
	recalcOrignalText()
