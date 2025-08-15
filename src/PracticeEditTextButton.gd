extends MarginContainer

class_name PracticeEditTextButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var titleText
var startPos
var modifyDialog
var modifiedTitle=""
var modifiedExplainText=""

func _ready():
	if !GameState.mobileMode:
		GameEvents.register_allways_tooltip($HBoxContainer/Button,"ModifyText")
	

func init(titleTextPrm,startPosNr,modifyDialogPopup):
	titleText=titleTextPrm
	startPos=startPosNr
	modifyDialog=modifyDialogPopup
	modifiedTitle=Practices.getPracticeTranslation(startPosNr,false)
	modifiedExplainText=Practices.getPracticeExplainTranslation(startPosNr,false)
	setModifiedText()
	
func setModifiedText():
	if modifiedTitle=="" && modifiedExplainText=="": 
		$HBoxContainer/Label.text=""
	else:
		$HBoxContainer/Label.text=tr("TextModified")



func _on_Button_pressed():
	modifyDialog.init(titleText,modifiedTitle,self,modifiedExplainText,startPos)
	modifyDialog.show_modal(true)

func dialogSaved(newTitle,newExplainText):
	modifiedTitle=newTitle
	modifiedExplainText=newExplainText
	setModifiedText()


var hasFocus=false
var mouseHovered=false

func highlight():
	var button=$HBoxContainer/Button
	
	if  mouseHovered:
		button.modulate= Color(1,1,1,1)
	elif hasFocus:
		button.modulate= Color(1,1,1,0.9)
	else:
		button.modulate= Color(1,1,1,0.7)

	
func _on_Button_focus_entered() -> void:
	hasFocus=true
	highlight()


func _on_Button_focus_exited() -> void:
	hasFocus=false
	highlight()


func _on_Button_mouse_entered() -> void:
	mouseHovered=true
	highlight()


func _on_Button_mouse_exited() -> void:
	mouseHovered=false
	highlight()
