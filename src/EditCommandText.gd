extends MarginContainer

var command =0
var commandName= ""

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("languageChangedSignal",self,"_languageChangedSignal");

func _languageChangedSignal():
	recalcOrignalText()
	
func setText(text):
	$"LineEdit".text=text
	if (text==""): 
		text=commandName
	GameEvents.sendCommandChanged(command,commandName,text)
	recalcOrignalText()
	
func _on_LineEdit_text_changed(new_text):
	var textValue=$ "LineEdit".text;
	if (textValue==""): 
		textValue=commandName
	GameEvents.sendCommandChanged(command,commandName,textValue)
	recalcOrignalText()
	
func recalcOrignalText():
	if $"LineEdit".text=="":
		$LineEdit/OriginalText.text=Utilities.calcButtonTextFromCommand(commandName,command)
	else:
		$LineEdit/OriginalText.text=""
		

func _on_EditTooltipText_gui_input(event: InputEvent) -> void:
	recalcOrignalText()
