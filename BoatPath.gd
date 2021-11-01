extends Node2D


var color=Color(1.0, 0.0, 0.0)
var points_arc=PoolVector2Array()
var prevPos= Vector2(0,0)
var debug=true;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  debug:
		var ticks=OS.get_ticks_msec()
		var pos=$"../Boat".position
		if (pos-prevPos).length()>10:
			points_arc.push_back(pos)
			prevPos=pos;
			update()		

func _draw():
	if debug:
		for point in points_arc:
			draw_circle(point,4,color)
	
