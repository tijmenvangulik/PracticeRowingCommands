extends Node2D


var color=Color(1.0, 0.0, 0.0)
var points_arc=PoolVector2Array()
var prevPos= Vector2(0,0)

func debugMode():
	return $"../CanvasLayer/ControlPanel".visible
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	
	if  debugMode():
		var ticks=OS.get_ticks_msec()
		var pos=$"../Boat".position
		if (pos-prevPos).length()>10:
			points_arc.push_back(pos)
			prevPos=pos;
			update()		
	else: if points_arc.size()>0:
		points_arc=PoolVector2Array()
		update()	
		
func _draw():
	if debugMode():
		for point in points_arc:
			draw_circle(point,4,color)
	
