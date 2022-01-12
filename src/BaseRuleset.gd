extends Node

class_name BaseRuleset

var error=""

func setError(errorMsg:String)->void:
	error=errorMsg
	
func clearError()->void:
	error=""

func determinenewState(boat,newState:int,direction:int) -> int:
	return newState;

func determineOarsState(boat,command : int) -> int:
	return boat.stateOars
	
func determineLightPaddleState(boat,newLightPaddle:bool) -> bool:
	return newLightPaddle
	
func determineBestState(boat,newBestState :int) -> int:
	return newBestState
