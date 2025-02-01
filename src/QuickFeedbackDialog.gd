extends WindowDialog



# Called when the node enters the scene tree for the first time.
func _ready():
	get_close_button().hide()

func handleShow():
	GameState.dialogIsOpen=visible
		
func _init():
	connect("visibility_changed",self,"handleShow");


func _on_CancelFeedback_pressed():
	hide()

func _on_SendFeedback_pressed():	
	$FeedBackContainer.sendFeedBack()
	hide()

