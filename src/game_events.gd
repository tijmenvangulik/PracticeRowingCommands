extends Node

signal customCommandTextChanged(command,commandName,value)

signal customTooltipTextChanged(command,commandName,value)

signal customShortcutTextChanged(command,commandName,value)

signal settingsChangedSignal

signal languageChangedSignal

signal zoomChangedSignal

signal forwardBackwardsChangedSignal

signal collectGameStateChangedSignal(newState)

signal commandsChanged(commandArray)

signal introSignal(isVisible)


signal customButtonSetChangedSignal

signal showButtonsSignal

signal doCommandSignal(command)

signal toggle_tooltip(do_show,tooltip_type)

signal startTour

signal customCommandText2Changed

signal startPlay

signal isScullChangedSignal

signal highContrastChangedSignal

signal crash

signal practicesChanged

signal settingsLoadedSignal

signal loadedSharedSettings 

signal windowSizeChanged

func sendCommandChanged(command : int,commandName :String,value : String) -> void:
	emit_signal("customCommandTextChanged",command,commandName,value)

func sendCommandText2Changed(command : int,commandName :String,value : String) -> void:
	emit_signal("customCommandText2Changed",command,commandName,value)

# call_deferred("emit_signal","customCommandTextChanged")

func sendTooltipChanged(command : int,commandName :String,value : String) -> void:
	emit_signal("customTooltipTextChanged",command,commandName,value)

func sendShortcutChanged(command : int,commandName :String,value : String) -> void:
	emit_signal("customShortcutTextChanged",command,commandName,value)

func startPlay():
 call_deferred("emit_signal","startPlay")

func settingsChanged():
 emit_signal("settingsChangedSignal")

func languageChanged():
	emit_signal("languageChangedSignal")
	
func zoomChanged():
	emit_signal("zoomChangedSignal")

func loadedSharedSettings():
	emit_signal("loadedSharedSettings")
	
func forwardBackwardsChanged():
	emit_signal("forwardBackwardsChangedSignal")

func collectGameStateChanged(newState ):
	call_deferred("emit_signal","collectGameStateChangedSignal",newState)

func commandsChanged(commandArray : Array):
	emit_signal("commandsChanged",commandArray)

func intro(isVisible:bool):
	call_deferred("emit_signal","introSignal",isVisible)

func customButtonSetChanged():
	emit_signal("customButtonSetChangedSignal")
func showButtons(show : bool):
	emit_signal("showButtonsSignal",show)
	
func doCommand(command:int):
	emit_signal("doCommandSignal",command)

func isScullChanged(isScull:bool):
	emit_signal("isScullChangedSignal",isScull)

func highContrastChanged(highContrast:bool):
	emit_signal("highContrastChangedSignal",highContrast)
	
func crash():
	emit_signal("crash")

func practicesChanged():
	emit_signal("practicesChanged")
	
#you can put other stuff here, like maybe a path to a custom panel to put
#into the tooltip scene. I have basiscs like which type it is and where it should
#be positioned.
func register_tooltip(control_node, tooltip_type):
	control_node.connect("mouse_entered",self,"_on_show_tooltip",[control_node,tooltip_type])
	control_node.connect("mouse_exited",self,"_on_hide_tooltip",[control_node,tooltip_type])
	
func register_allways_tooltip(control_node, tooltip_type,includeFocus=false):
	control_node.connect("mouse_entered",self,"_on_allways_show_tooltip",[control_node,tooltip_type])
	control_node.connect("mouse_exited",self,"_on_allways_hide_tooltip",[control_node,tooltip_type])
	if includeFocus:
		control_node.connect("focus_entered",self,"_on_allways_show_tooltip",[control_node,tooltip_type])
		control_node.connect("focus_exited",self,"_on_allways_hide_tooltip",[control_node,tooltip_type])

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

func startTour():
	emit_signal("startTour")

func settingsLoaded():
	emit_signal("settingsLoadedSignal")

func _sizeChanged():
	emit_signal("windowSizeChanged")

func _ready():
	get_tree().get_root().connect("size_changed",self,"_sizeChanged")
