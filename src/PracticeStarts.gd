extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hideAll()

func hideAll():
	for c in self.get_children():
		c.hide()
		
func collect(amount):
	$"%OptionStart".endPractice();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
