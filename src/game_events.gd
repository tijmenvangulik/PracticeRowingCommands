extends Node

signal customCommandTextChanged(command,commandName,value)

signal customTooltipTextChanged(command,commandName,value)

signal settingsChangedSignal

signal languageChangedSignal

signal zoomChangedSignal

signal forwardBackwardsChangedSignal

signal collectGameStateChangedSignal(newState)

signal commandsChangedSignal(commandArray)

signal introSignal(isVisible)

signal disableCommandSignal(name,disabled)

signal customButtonSetChangedSignal

signal showButtonsSignal

signal doCommandSignal(command)

signal toggle_tooltip(do_show,tooltip_type)


func sendCommandChanged(command : int,commandName :String,value : String) -> void:
	emit_signal("customCommandTextChanged",command,commandName,value)
# call_deferred("emit_signal","customCommandTextChanged")

func sendTooltipChanged(command : int,commandName :String,value : String) -> void:
	emit_signal("customTooltipTextChanged",command,commandName,value)



func settingsChanged():
 emit_signal("settingsChangedSignal")

func languageChanged():
	emit_signal("languageChangedSignal")
	
func zoomChanged():
	emit_signal("zoomChangedSignal")

func forwardBackwardsChanged():
	emit_signal("forwardBackwardsChangedSignal")

func collectGameStateChanged(newState ):
	call_deferred("emit_signal","collectGameStateChangedSignal",newState)

func commandsChanged(commandArray : Array):
	emit_signal("commandsChangedSignal",commandArray)

func intro(isVisible:bool):
	call_deferred("emit_signal","introSignal",isVisible)

func disableCommand(name:String,disabled:bool):
	emit_signal("disableCommandSignal",name,disabled)

func customButtonSetChanged():
	emit_signal("customButtonSetChangedSignal")
func showButtons(show : bool):
	emit_signal("showButtonsSignal",show)
	
func doCommand(command:int):
	emit_signal("doCommandSignal",command)

#you can put other stuff here, like maybe a path to a custom panel to put
#into the tooltip scene. I have basiscs like which type it is and where it should
#be positioned.
func register_tooltip(control_node, tooltip_type):
	control_node.connect("mouse_entered",self,"_on_show_tooltip",[control_node,tooltip_type])
	control_node.connect("mouse_exited",self,"_on_hide_tooltip",[control_node,tooltip_type])
	
func register_allways_tooltip(control_node, tooltip_type):
	control_node.connect("mouse_entered",self,"_on_allways_show_tooltip",[control_node,tooltip_type])
	control_node.connect("mouse_exited",self,"_on_allways_hide_tooltip",[control_node,tooltip_type])

#The register_tooltip method essentially adds these methods to each class 
# you're registering a tooltip for. This makes adding a tooltip possible in 
# a root node without having to create a script for every UI element in the
# ui scene. See Button.gd
func _on_show_tooltip(node,tooltip_type):
	if GameState.showTooltips:
		emit_signal("toggle_tooltip",true, node, tooltip_type)
	
func _on_hide_tooltip(node,tooltip_type):
	if GameState.showTooltips:
		emit_signal("toggle_tooltip",false, node, tooltip_type)
		
func _on_allways_show_tooltip(node,tooltip_type):
		emit_signal("toggle_tooltip",true, node, tooltip_type)
	
func _on_allways_hide_tooltip(node,tooltip_type):
		emit_signal("toggle_tooltip",false, node, tooltip_type)


