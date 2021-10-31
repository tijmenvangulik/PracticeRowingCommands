extends Node2D

func _init():
   TranslationServer.set_locale("nl_NL")
	
# jp is dutch viking

func _ready():
	$"CanvasLayer/IntroDialog".visible=true
	$"CanvasLayer/OptionStart".visible=false
	$"CanvasLayer/OptionCommands".visible=false
	
func set_camera_limits():
	var map_limits = $TileMap.get_used_rect()
	var map_cellsize = $TileMap.cell_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#var prevTicks=0

#var color=Color(1.0, 0.0, 0.0)
#var points_arc=PoolVector2Array()

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func _process(delta):
#	var ticks=OS.get_ticks_msec()
#	if ticks-prevTicks>1000:
#		prevTicks=ticks
#		var pos=$"Boat".position
#		points_arc.push_back(pos)
#		update()		

#func _draw():
#	draw_circle(Vector2(100,100),10,color)
#	for point in points_arc:
#		draw_circle(point,10,color)
	
