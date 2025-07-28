extends WindowDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()

func start():
	if !GameState.isReplaying:
		$HBoxContainer/StartSamePractice.grab_focus()
		show_modal(true)
	
	
func _on_StartSamePractice_pressed():
	hide()
	$"%OptionStart".restartPractice()


func _on_CancelPractice_pressed():
	$"%OptionStart".startOnWater()
	hide()
