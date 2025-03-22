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
	pass # Replace with function body.

func init(titleTextPrm,startPosNr,modifyDialogPopup):
	titleText=titleTextPrm
	startPos=startPosNr
	modifyDialog=modifyDialogPopup
	modifiedTitle=Practices.getPracticeTranslation(startPosNr)
	modifiedExplainText=Practices.getPracticeExplainTranslation(startPosNr)
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
