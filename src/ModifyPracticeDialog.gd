extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var modifiedTitle=""
var titleText=""
var sender : PracticeEditTextButton

var modifiedExplainText=""
var startPos=""
# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	if GameState.mobileMode:
		$ModifiedTitle.rect_min_size.y=35
	
func init(title,modifiedTitlePrm,senderParam,modifiedExplainTextPrm,startPosPrm):
	titleText=title
	sender=senderParam
	startPos=startPosPrm
	$Title.text=title	
	modifiedTitle=modifiedTitlePrm
	$ModifiedTitleCheckBox.pressed=modifiedTitle!=""
	$ModifiedTitle.text=modifiedTitlePrm

	modifiedExplainText=modifiedExplainTextPrm
	$ModifiedExplainTextCheckBox.pressed=modifiedExplainText!=""
	$ModifiedExplainText.text=modifiedExplainTextPrm
	
	enableDisable()

func _on_Cancel_pressed():
	hide()

func _on_Ok_pressed():
	if $ModifiedTitleCheckBox.pressed:
		modifiedTitle= $ModifiedTitle.text
	else:
		modifiedTitle=""
	if $ModifiedExplainTextCheckBox.pressed:
		modifiedExplainText= $ModifiedExplainText.text
	else:
		modifiedExplainText=""

	sender.dialogSaved(modifiedTitle,modifiedExplainText)
	hide()

func enableDisable():
	$ModifiedTitle.readonly=!$ModifiedTitleCheckBox.pressed	
	if !$ModifiedTitleCheckBox.pressed:
		$ModifiedTitle.text=tr("ClickSwitchHint")

	$ModifiedExplainText.readonly=!$ModifiedExplainTextCheckBox.pressed	
	if !$ModifiedExplainTextCheckBox.pressed:
		$ModifiedExplainText.text=tr("ClickSwitchHintExplainText")

func _on_ModifiedTitleCheckBox_pressed():
	enableDisable()
	if $ModifiedTitleCheckBox.pressed:
		$ModifiedTitle.text=tr(titleText)
	
func _on_ModifiedTextCheckBox_pressed():
	enableDisable()
	if $ModifiedExplainTextCheckBox.pressed:
		var explainText=Practices.getPracticeExplainText(startPos)
		$ModifiedExplainText.text=Utilities.replaceCommandsInText(tr(explainText),true)
