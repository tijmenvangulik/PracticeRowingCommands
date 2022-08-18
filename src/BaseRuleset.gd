extends Node

class_name BaseRuleset

var error=""

func setError(errorMsg:String)->void:
	error=errorMsg
	
func clearError()->void:
	error=""

func determinenewState(boat,command:int,newState:int,direction:int) -> int:
	return newState;

func determineOarsState(boat,command:int,oarsCommand : int) -> int:
	return boat.stateOars
	
func determineLightPaddleState(boat,command: int,newLightPaddle:bool) -> bool:
	return newLightPaddle
	
func determineBestState(boat,command: int,newBestState :int) -> int:
	return newBestState
