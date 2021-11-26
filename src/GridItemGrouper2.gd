extends PanelContainer


signal button_droppedOnGrouper(droppedInfo,groupItem)

func getHorizontalGroup():
	return $"GridItemGrouperHoriz2"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func can_drop_data(_pos, data):
	return typeof(data) == TYPE_DICTIONARY && data["command"]!=null


func drop_data(_pos, data):
	emit_signal("button_droppedOnGrouper",data,self)
