extends MarginContainer

class_name PracticeEditTextButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var titleText
var startPos
var modifyDialog
var modifiedTitle=""

func _ready():
	pass # Replace with function body.

func init(text,startPosNr,modifyDialogPopup):
	titleText=text
	startPos=startPosNr
	modifyDialog=modifyDialogPopup
	modifiedTitle=Practices.getPracticeTranslation(startPosNr)
	setModifiedText()
	
func setModifiedText():
	if modifiedTitle=="": 
		$HBoxContainer/Label.text=""
	else:
		$HBoxContainer/Label.text=tr("TextModified")

func _on_Button_pressed():
	modifyDialog.init(titleText,modifiedTitle,self)
	modifyDialog.show_modal(true)

func dialogSaved(newTitle):
	modifiedTitle=newTitle
	setModifiedText()
