extends Button


func _pressed():
	owner.execCommand()

func get_drag_data(_pos):
	if (!owner.canDrag): return null
	# Use another colorpicker as drag preview.
	var cpb = Button.new()
	cpb.rect_size = Vector2(100, 30)
	cpb.text=text
	set_drag_preview(cpb)
	# Return color as drag data.
	return {"command":owner.command,
	 "commandName":owner.commandName,
	 "text":text,
	 "dragButton":$".."}
	

func can_drop_data(_pos, data):
	return typeof(data) == TYPE_DICTIONARY && data["command"]!=null


func drop_data(_pos, data):
	owner.callButtonDropped(data)
