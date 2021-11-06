extends RichTextLabel


func _gui_input(event):
	if event is InputEventMouseButton:
		JavaScript.eval("window.open('https://github.com/tijmenvangulik/PracticeRowingCommands')")
 
