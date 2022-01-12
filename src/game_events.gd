extends Node

signal customCommandTextChanged(command,commandName,value)

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

func sendCommandChanged(command : int,commandName :String,value : String) -> void:
	emit_signal("customCommandTextChanged",command,commandName,value)
# call_deferred("emit_signal","customCommandTextChanged")

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
	
