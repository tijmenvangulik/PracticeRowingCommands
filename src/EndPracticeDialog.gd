extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(earnedStar):
	$EndPracticeStar.visible=earnedStar
	$HBoxContainer/StartNextPractice.grab_focus()
	show_modal(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartNextPractice_pressed():
	hide()
	$"%OptionStart".nextPractice()


func _on_CancelPractice_pressed():
	$"%OptionStart".startOnWater()
	hide()
