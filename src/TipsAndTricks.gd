extends WindowDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()
	if GameState.mobileMode:
		anchor_left=0.02
		anchor_right=0.98
		margin_right=0
func start():
	show_modal(true)
	$"AllCrashTips".set_bbcode(Utilities.replaceCommandsInText(tr("AllCrashTips"),true) )

func _on_Close_pressed() -> void:
	hide()

func setWidth():
	margin_right=0

func _sizeChanged():
	setWidth()

