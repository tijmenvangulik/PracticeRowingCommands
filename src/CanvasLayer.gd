extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if  GameState.mobileMode:
		$errorLabel.add_font_override("font",load("res://FontExtraLarge.tres"))
		$errorLabel.anchor_left=0.1
		$"%replayCommandText".add_font_override("font",load("res://FontExtraLarge.tres"))
		$"%replayCommandText".anchor_left=0.1
