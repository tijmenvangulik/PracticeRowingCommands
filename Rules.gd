extends Node


var error=""

func setError(errorMsg):
	error=errorMsg
	
func clearError():
	error=""
	
func determinenewState(boat,newState:int,direction:int):
	clearError()
	var state=boat.state
	var stateOars=boat.stateOars
	var result=state;
	if stateOars==boat.StateOars.Slippen &&  newState!=boat.RowState.Bedankt && newState!=boat.RowState.PeddelendStrijkenBB && newState!=boat.RowState.PeddelendStrijkenSB :
		setError("EerstUitBrengen")	
		return result
	if stateOars!=boat.StateOars.Roeien &&  stateOars!=boat.StateOars.RiemenHoogSB && stateOars!=boat.StateOars.RiemenHoogBB && (newState==boat.RowState.HalenBeideBoorden || newState==boat.RowState.StrijkenBeidenBoorden  || newState==boat.RowState.RondmakenSB  || newState==boat.RowState.RondmakenBB ):
		setError("EerstUitBrengen")	
		return result
	else: if stateOars==boat.StateOars.SlippenBB && (newState==boat.RowState.HalenBB || newState==boat.RowState.StrijkenBB || newState==boat.RowState.VastroeienBB):
		setError("EerstUitBrengen")	
		return result
	else: if stateOars==boat.StateOars.SlippenSB && (newState==boat.RowState.HalenSB || newState==boat.RowState.StrijkenSB || newState==boat.RowState.VastroeienSB) :
		setError("EerstUitBrengen")	
		return result
	else: if newState==boat.RowState.PeddelendStrijkenSB && (stateOars!=boat.StateOars.SlippenSB && stateOars!=boat.StateOars.Slippen ):
		setError("EerstSlippen")	
		return result
	else: if newState==boat.RowState.PeddelendStrijkenBB && (stateOars!=boat.StateOars.SlippenBB && stateOars!=boat.StateOars.Slippen ):
		setError("EerstSlippen")	
		return result
	else: if newState==boat.RowState.Bedankt &&  !boat.isLowSpeed() && (state==boat.RowState.HalenBeideBoorden ):
		setError("EerstLatenLopen")
		return result
	else: if newState==boat.RowState.UitzettenSB && stateOars!=boat.StateOars.SlippenSB && stateOars!=boat.StateOars.RiemenHoogSB:
		setError("RiemenMoetenHoogZijn")
		return result
	else: if newState==boat.RowState.UitzettenBB && stateOars!=boat.StateOars.SlippenBB && stateOars!=boat.StateOars.RiemenHoogBB:
		setError("RiemenMoetenHoogZijn")
		return result
	else: if (newState==boat.RowState.UitzettenSB || newState==boat.RowState.UitzettenBB) && !boat.isLowSpeed():
		setError("LegBootStil")
		return result
	else: if newState==boat.RowState.LaatLopen || newState==boat.RowState.Bedankt || boat.isLowSpeed():
		result=newState
		return result
	else:
		var currentDirection=0
		if boat.calcSpeed()<0:  currentDirection=-1
		else: currentDirection=1
		if (state==boat.RowState.LaatLopen || state==boat.RowState.Bedankt)  :
			if  direction!=0 && direction!=currentDirection && !boat.isLowSpeed():
				setError("LegBootStil")
				return result
			result=newState
				
		else:
			setError("EerstLatenLopenOfBedankt")
	
	return result;

func determineOarsState(boat,command : int):
	clearError()

	var stateOars=boat.stateOars
	if boat.boatInRest():
		match command:
			boat.OarsCommand.Slippen:
				if stateOars==boat.StateOars.Roeien:
					return boat.StateOars.Slippen
				else: 
					setError("CommandIsAlreadyActive")
			boat.OarsCommand.Uitbrengen:
				if stateOars==boat.StateOars.Slippen:
					return boat.StateOars.Roeien
				else:
					setError("EerstSlippen")
			boat.OarsCommand.SlippenBB:
				
				if stateOars==boat.StateOars.Roeien:
					return boat.StateOars.SlippenBB
				else: if stateOars==boat.StateOars.SlippenSB:
					return boat.StateOars.Slippen
				else: setError("CommandIsAlreadyActive")	
			boat.OarsCommand.UitbrengenBB:
				if stateOars==boat.StateOars.SlippenBB:
					return boat.StateOars.Roeien
				else: if stateOars==boat.StateOars.Slippen:
					return boat.StateOars.SlippenSB
				else: setError("EerstSlippen")	
			boat.OarsCommand.SlippenSB:
				if stateOars==boat.StateOars.Roeien:
					return boat.StateOars.SlippenSB
				else: if stateOars==boat.StateOars.SlippenBB:
					return boat.StateOars.Slippen
				else: setError("CommandIsAlreadyActive")	
			boat.OarsCommand.UitbrengenSB:
				if stateOars==boat.StateOars.SlippenSB:
					return boat.StateOars.Roeien
				else: if stateOars==boat.StateOars.Slippen:
					return boat.StateOars.SlippenBB
				else: setError("EerstSlippen")
			boat.OarsCommand.RiemenHoogSB:
				if stateOars==boat.StateOars.Roeien :
					return boat.StateOars.RiemenHoogSB
				else: setError("RiemenHoogAlleenAlsRiemenUitgebracht")	
				
			boat.OarsCommand.RiemenHoogBB:					
				if stateOars==boat.StateOars.Roeien:
					return boat.StateOars.RiemenHoogBB
				else: setError("RiemenHoogAlleenAlsRiemenUitgebracht")	
	else: 
		setError("EerstLatenLopenOfBedankt")
	return stateOars

func determineLightPaddleState(boat,newLightPaddle:bool):
	clearError()
	if newLightPaddle==boat.lightPaddleOn:
		setError("CommandIsAlreadyActive")
	else: return newLightPaddle
	return boat.lightPaddleOn

	
func determineBestState(boat,newBestState :int):
	clearError()
	var bestState=boat.bestState
	var state=boat.state
	if newBestState==boat.BestState.Normal:
		if bestState!=boat.BestState.StuurboordBest && bestState!= boat.BestState.BakboordBest:
			setError("BestIsNietActief")
			return bestState
	if (state!=boat.RowState.HalenBeideBoorden):
		setError("BestAlleenTijdensHalen")
	else: 
		if newBestState!=boat.BestState.Normal && bestState!=boat.BestState.Normal:
			setError("CommandIsAlreadyActive")
	return newBestState

