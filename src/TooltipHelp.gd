extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tooltipText="ShowHideTootipsTooltip"

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.register_allways_tooltip(self,tooltipText)


func _pressed():
	if !self.pressed:
		GameEvents._on_hide_tooltip(self,"")
	GameState.showTooltips=self.pressed
	if GameState.showTooltips:
		GameEvents._on_show_tooltip(self,tooltipText)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
