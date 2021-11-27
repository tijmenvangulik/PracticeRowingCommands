extends Node


var error=""

func determinenewState(boat,newState:int,direction:int):	
	return newState;

func determineOarsState(boat,command : int):

	var stateOars=boat.stateOars
	match command:
		boat.OarsCommand.Slippen:
				return boat.StateOars.Slippen
		boat.OarsCommand.Uitbrengen:
				return boat.StateOars.Roeien
		boat.OarsCommand.SlippenBB:			
			if stateOars==boat.StateOars.SlippenSB:
				return boat.StateOars.Slippen
			else: if stateOars==boat.StateOars.Roeien:
				return boat.StateOars.SlippenBB
		boat.OarsCommand.UitbrengenBB:
			if stateOars==boat.StateOars.Slippen:
				return boat.StateOars.SlippenSB
			else:
				return boat.StateOars.Roeien
		boat.OarsCommand.SlippenSB:
			if stateOars==boat.StateOars.SlippenBB:
				return boat.StateOars.Slippen
			else:
				return boat.StateOars.SlippenSB
		boat.OarsCommand.UitbrengenSB:
			if stateOars==boat.StateOars.Slippen:
				return boat.StateOars.SlippenBB
			else:
				return boat.StateOars.Roeien
		boat.OarsCommand.RiemenHoogSB:
			return boat.StateOars.RiemenHoogSB
			
		boat.OarsCommand.RiemenHoogBB:					
			return boat.StateOars.RiemenHoogBB
	return stateOars

func determineLightPaddleState(boat,newLightPaddle:bool):
	return newLightPaddle

	
func determineBestState(boat,newBestState :int):
	return newBestState

