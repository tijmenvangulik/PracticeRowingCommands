extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func start():
	show_modal(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ShareSettings_pressed():
	hide()
	$"%ShareSettingsDialog".start($NameContainer/Name.text)


func _on_Cancel_pressed():
	hide()
