extends BaseRuleset

func determinenewState(boat: Boat,newState:int,direction:int)-> int:
	return newState;

func determineOarsState(boat: Boat,command : int)-> int:

	var stateOars=boat.stateOars
	match command:
		Constants.OarsCommand2.Slippen:
				return Constants.StateOars.Slippen
		Constants.OarsCommand2.Uitbrengen:
				return Constants.StateOars.Roeien
		Constants.OarsCommand2.SlippenBB:			
			if stateOars==Constants.StateOars.SlippenSB:
				return Constants.StateOars.Slippen
			else: if stateOars==Constants.StateOars.Roeien:
				return Constants.StateOars.SlippenBB
		Constants.OarsCommand2.UitbrengenBB:
			if stateOars==Constants.StateOars.Slippen:
				return Constants.StateOars.SlippenSB
			else:
				return Constants.StateOars.Roeien
		Constants.OarsCommand2.SlippenSB:
			if stateOars==Constants.StateOars.SlippenBB:
				return Constants.StateOars.Slippen
			else:
				return Constants.StateOars.SlippenSB
		Constants.OarsCommand2.UitbrengenSB:
			if stateOars==Constants.StateOars.Slippen:
				return Constants.StateOars.SlippenBB
			else:
				return Constants.StateOars.Roeien
		Constants.OarsCommand2.RiemenHoogSB:
			return Constants.StateOars.RiemenHoogSB
			
		Constants.OarsCommand2.RiemenHoogBB:					
			return Constants.StateOars.RiemenHoogBB
	return stateOars

func determineLightPaddleState(boat: Boat,newLightPaddle:bool)-> bool:
	return newLightPaddle

	
func determineBestState(boat: Boat,newBestState :int)-> int:
	return newBestState

