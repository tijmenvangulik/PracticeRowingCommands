extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	changeVisible(false)

func changeVisible(visible):
	$Line2D.visible=visible
	$BuoyOrange.changeVisible(visible)
	$BuoyOrange2.changeVisible(visible)
	$BuoyOrange3.changeVisible(visible)
	if visible:
		$Collectable1.reset()
		$Collectable2.reset()
	else:
		$Collectable1.hide()
		$Collectable2.hide()
		
func collect(star):
	pass
