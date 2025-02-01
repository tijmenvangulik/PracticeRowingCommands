extends WindowDialog

func _ready():
	get_close_button().hide()

func start(earnedStar):
	show_modal(true)

func _on_StartNextPractice_pressed():
	hide()
	$FeedBackContainer.sendFeedBack()
	$"%OptionStart".nextPractice()

func _on_CancelNextPractice_pressed():
	$FeedBackContainer.sendFeedBack()
	$"%OptionStart".startOnWater()
	hide()

