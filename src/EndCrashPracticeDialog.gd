extends WindowDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	if GameState.mobileMode:
	
		margin_bottom=480
		$CrashTips.margin_top-=40
		$HBoxContainer.margin_top-=50
		$HBoxContainer.margin_bottom-=50
func start():
	if !GameState.isReplaying:
		$HBoxContainer/StartSamePractice.grab_focus()
		show_modal(true)
	setText()
	
func _on_StartSamePractice_pressed():
	hide()
	$"%OptionStart".restartPractice()


func _on_CancelPractice_pressed():
	$"%OptionStart".startOnWater()
	hide()

func setText():
	$"CrashTips".set_bbcode(tr("CrashTips"))
	
func _on_RichTextLabel_meta_clicked(meta) -> void:
	$"%TipsAndTricks".start()
