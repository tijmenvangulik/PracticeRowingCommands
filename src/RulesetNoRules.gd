extends BaseRuleset

func determinenewState(boat: Boat,command:int,newState:int,direction:int)-> int:
	return newState;

func determineOarsState(boat: Boat,command,oarsCommand )-> int:

	var stateOars=boat.stateOars
	match oarsCommand:
		Constants.OarsCommand2.Slippen:
			if !Settings.isScull:
				return stateOars
			return Constants.StateOars.Slippen
		Constants.OarsCommand2.Uitbrengen:
			if !Settings.isScull:
				return stateOars
			return Constants.StateOars.Roeien
		Constants.OarsCommand2.SlippenBB:
			if !Settings.isScull:
				return stateOars
			if stateOars==Constants.StateOars.SlippenSB:
				return Constants.StateOars.Slippen
			else: if stateOars==Constants.StateOars.Roeien:
				return Constants.StateOars.SlippenBB
		Constants.OarsCommand2.UitbrengenBB:
			if stateOars==Constants.StateOars.IntrekkenBB:
				return Constants.StateOars.Roeien
			if stateOars==Constants.StateOars.Slippen:
				return Constants.StateOars.SlippenSB
			else:
				return Constants.StateOars.Roeien
		Constants.OarsCommand2.SlippenSB:
			if !Settings.isScull:
				return stateOars
			if stateOars==Constants.StateOars.SlippenBB:
				return Constants.StateOars.Slippen
			else:
				return Constants.StateOars.SlippenSB
		Constants.OarsCommand2.UitbrengenSB:
			if stateOars==Constants.StateOars.IntrekkenSB:
				return Constants.StateOars.Roeien
			if stateOars==Constants.StateOars.Slippen:
				return Constants.StateOars.SlippenBB
			else:
				return Constants.StateOars.Roeien
		Constants.OarsCommand2.RiemenHoogSB:
			return Constants.StateOars.RiemenHoogSB
			
		Constants.OarsCommand2.RiemenHoogBB:
			return Constants.StateOars.RiemenHoogBB
		Constants.OarsCommand2.IntrekkenBB:
			if stateOars==Constants.StateOars.Roeien:
				return Constants.StateOars.IntrekkenBB
		Constants.OarsCommand2.IntrekkenSB:
			if stateOars==Constants.StateOars.Roeien:
				return Constants.StateOars.IntrekkenSB
			
	return stateOars

func determineLightPaddleState(boat: Boat,command: int,newLightPaddle:bool)-> bool:
	return newLightPaddle

	
func determineBestState(boat: Boat,command: int,newBestState :int)-> int:
	return newBestState

