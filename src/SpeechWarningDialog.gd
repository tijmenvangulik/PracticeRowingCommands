extends WindowDialog

# warning shown the first time the speak button is used

signal closed

func _ready():
	get_close_button().hide()
	connect("popup_hide",self,"_on_popup_hide")
	if GameState.mobileMode:
		anchor_left=0.1
		anchor_right=0.9
		margin_right=0

func start():
	show_modal(true)
	$"WarningText".set_bbcode(Utilities.replaceCommandsInText(tr("SpeechExperimentalWarning"),true) )

func _on_Close_pressed() -> void:
	hide()

func _on_popup_hide():
	emit_signal("closed")
