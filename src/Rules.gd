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
	if stateOars==Constants.StateOars.Slippen &&  newState!=Constants.RowState.Bedankt && newState!=Constants.RowState.PeddelendStrijkenBB && newState!=Constants.RowState.PeddelendStrijkenSB :
		setError("EerstUitBrengen")	
		return result
	if stateOars!=Constants.StateOars.Roeien &&  stateOars!=Constants.StateOars.RiemenHoogSB && stateOars!=Constants.StateOars.RiemenHoogBB && (newState==Constants.RowState.HalenBeideBoorden || newState==Constants.RowState.StrijkenBeidenBoorden  || newState==Constants.RowState.RondmakenSB  || newState==Constants.RowState.RondmakenBB ):
		setError("EerstUitBrengen")	
		return result
	else: if stateOars==Constants.StateOars.SlippenBB && (newState==Constants.RowState.HalenBB || newState==Constants.RowState.StrijkenBB || newState==Constants.RowState.VastroeienBB):
		setError("EerstUitBrengen")	
		return result
	else: if stateOars==Constants.StateOars.SlippenSB && (newState==Constants.RowState.HalenSB || newState==Constants.RowState.StrijkenSB || newState==Constants.RowState.VastroeienSB) :
		setError("EerstUitBrengen")	
		return result
	else: if newState==Constants.RowState.PeddelendStrijkenSB && (stateOars!=Constants.StateOars.SlippenSB && stateOars!=Constants.StateOars.Slippen ):
		setError("EerstSlippen")	
		return result
	else: if newState==Constants.RowState.PeddelendStrijkenBB && (stateOars!=Constants.StateOars.SlippenBB && stateOars!=Constants.StateOars.Slippen ):
		setError("EerstSlippen")	
		return result
	else: if newState==Constants.RowState.Bedankt &&  !boat.isLowSpeed() && (state==Constants.RowState.HalenBeideBoorden ):
		setError("EerstLatenLopen")
		return result
	else: if newState==Constants.RowState.UitzettenSB && stateOars!=Constants.StateOars.SlippenSB && stateOars!=Constants.StateOars.RiemenHoogSB:
		setError("RiemenMoetenHoogZijn")
		return result
	else: if newState==Constants.RowState.UitzettenBB && stateOars!=Constants.StateOars.SlippenBB && stateOars!=Constants.StateOars.RiemenHoogBB:
		setError("RiemenMoetenHoogZijn")
		return result
	else: if (newState==Constants.RowState.UitzettenSB || newState==Constants.RowState.UitzettenBB) && !boat.isLowSpeed():
		setError("LegBootStil")
		return result
	else: if newState==Constants.RowState.LaatLopen || newState==Constants.RowState.Bedankt || boat.isLowSpeed():
		result=newState
		return result
	else:
		var currentDirection=0
		if boat.calcSpeed()<0:  currentDirection=-1
		else: currentDirection=1
		if (state==Constants.RowState.LaatLopen || state==Constants.RowState.Bedankt)  :
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
			Constants.OarsCommand2.Slippen:
				if stateOars==Constants.StateOars.Roeien:
					return Constants.StateOars.Slippen
				else: 
					setError("CommandIsAlreadyActive")
			Constants.OarsCommand2.Uitbrengen:
				if stateOars==Constants.StateOars.Slippen:
					return Constants.StateOars.Roeien
				else:
					setError("EerstSlippen")
			Constants.OarsCommand2.SlippenBB:
				
				if stateOars==Constants.StateOars.Roeien:
					return Constants.StateOars.SlippenBB
				else: if stateOars==Constants.StateOars.SlippenSB:
					return Constants.StateOars.Slippen
				else: setError("CommandIsAlreadyActive")	
			Constants.OarsCommand2.UitbrengenBB:
				if stateOars==Constants.StateOars.SlippenBB:
					return Constants.StateOars.Roeien
				else: if stateOars==Constants.StateOars.Slippen:
					return Constants.StateOars.SlippenSB
				else: setError("EerstSlippen")	
			Constants.OarsCommand2.SlippenSB:
				if stateOars==Constants.StateOars.Roeien:
					return Constants.StateOars.SlippenSB
				else: if stateOars==Constants.StateOars.SlippenBB:
					return Constants.StateOars.Slippen
				else: setError("CommandIsAlreadyActive")	
			Constants.OarsCommand2.UitbrengenSB:
				if stateOars==Constants.StateOars.SlippenSB:
					return Constants.StateOars.Roeien
				else: if stateOars==Constants.StateOars.Slippen:
					return Constants.StateOars.SlippenBB
				else: setError("EerstSlippen")
			Constants.OarsCommand2.RiemenHoogSB:
				if stateOars==Constants.StateOars.Roeien :
					return Constants.StateOars.RiemenHoogSB
				else: setError("RiemenHoogAlleenAlsRiemenUitgebracht")	
				
			Constants.OarsCommand2.RiemenHoogBB:					
				if stateOars==Constants.StateOars.Roeien:
					return Constants.StateOars.RiemenHoogBB
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
	if newBestState==Constants.BestState.Normal:
		if bestState!=Constants.BestState.StuurboordBest && bestState!= Constants.BestState.BakboordBest:
			setError("BestIsNietActief")
			return bestState
	if (state!=Constants.RowState.HalenBeideBoorden):
		setError("BestAlleenTijdensHalen")
	else: 
		if newBestState!=Constants.BestState.Normal && bestState!=Constants.BestState.Normal:
			setError("CommandIsAlreadyActive")
	return newBestState

