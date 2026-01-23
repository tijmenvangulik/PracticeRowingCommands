extends Button


func _pressed():
	owner.execCommand()

func get_drag_data(_pos):
	if (!owner.canDrag): return null
	# Use another colorpicker as drag preview.
	var cpb = Button.new()
	cpb.rect_size = Vector2(100, 30)
	if GameState.mobileMode:
		cpb.rect_pivot_offset.x=cpb.rect_size.x
		cpb.rect_pivot_offset.y=cpb.rect_size.y
		cpb.rect_scale.x=2
		cpb.rect_scale.y=2
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
