extends PanelContainer

func setChildNodeText(node,commandName,value):
	for N in node.get_children():
		if N.get_child_count() > 0:
			setChildNodeText(N,commandName,value)
		else:
			if N.name==commandName:
				N.text=value


func _on_EditCommandText_customCommandTextChanged(command,commandName, value):
	setChildNodeText(self, commandName,value)
