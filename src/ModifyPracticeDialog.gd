extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var modifiedTitle=""
var titleText=""
var sender : PracticeEditTextButton

# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()

func init(title,modifiedTitlePrm,senderParam):
	titleText=title
	sender=senderParam
	$Title.text=title	
	modifiedTitle=modifiedTitlePrm
	$ModifiedTitleCheckBox.pressed=modifiedTitle!=""
	$ModifiedTitle.text=modifiedTitlePrm
	enableDisable()

func _on_Cancel_pressed():
	hide()

func _on_Ok_pressed():
	if $ModifiedTitleCheckBox.pressed:
		modifiedTitle= $ModifiedTitle.text
	else:
		modifiedTitle=""
	sender.dialogSaved(modifiedTitle)
	hide()

func enableDisable():
	$ModifiedTitle.readonly=!$ModifiedTitleCheckBox.pressed	
	if !$ModifiedTitleCheckBox.pressed:
		$ModifiedTitle.text=tr("ClickSwitchHint")

func _on_ModifiedTitleCheckBox_pressed():
	enableDisable()
	if $ModifiedTitleCheckBox.pressed:
		$ModifiedTitle.text=tr(titleText)
	
