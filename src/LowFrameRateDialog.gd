extends WindowDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("visibility_changed",self,"handleShow");


func handleShow():
	if visible:
		doShow()
	else:
		Settings.checkFrameRateDisabled=true
		GameEvents.settingsChanged()
		
func doShow():
	if GameState.mobileMode:
		anchor_right=0
		margin_left=18
		margin_top=60		
		rect_size.x=370
		rect_size.y=110
		$Label.margin_top=12
		
		$SwitchToLow.rect_size.y=40
		Utilities.modifyCloseButton(self)
		
func _on_SwitchToLow_pressed() -> void:
	Settings.checkFrameRateDisabled=true
	GameEvents.settingsChanged()
	$"%SettingsDialog".switchResolution(1)
	visible=false
	
