extends WindowDialog

# warning shown the first time the speak button is used

signal closed

# full screen was on when the dialog was started: switch it on again when closing
var restoreFullScreen=false

func _ready():
	get_close_button().hide()
	connect("popup_hide",self,"_on_popup_hide")
	if GameState.mobileMode:
		anchor_left=0.1
		anchor_right=0.9
		margin_right=0

func start(wasFullScreen=false):
	restoreFullScreen=wasFullScreen
	show_modal(true)
	$"WarningText".set_bbcode(Utilities.replaceCommandsInText(tr("SpeechExperimentalWarning"),true) )

func _on_Close_pressed() -> void:
	hide()
	if restoreFullScreen && OS.has_feature('JavaScript'):
		restoreFullScreen=false
		# the permission prompt of the browser can have left full screen
		JavaScript.eval("if (!fullScreenActive()) fullscreen()")
	if OS.has_feature('JavaScript'):
		# listening has probably ended while the dialog was open: listen again
		$"%Speak".startListeningIfStopped()

func _on_popup_hide():
	emit_signal("closed")
