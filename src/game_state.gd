extends Node

var isViking=true
var isForwards=true

var collectGameState= Constants.CollectGameState.None

var collectGameLastTimeString =""
var collectGameIsHighScore=false

var defaultButtonSet=["HalenBeideBoorden","LaatLopen,Bedankt","VastroeienSB","HalenSB","StrijkenSB","StrijkenBeidenBoorden","VastroeienBeideBoorden","VastroeienBB","HalenBB","StrijkenBB","Slippen","SlippenSB","UitbrengenSB","PeddelendStrijkenSB","RondmakenSB","Uitbrengen","SlippenBB","UitbrengenBB","PeddelendStrijkenBB","RondmakenBB","LightPaddle","LightPaddleBedankt","RiemenHoogSB","RiemenHoogBB"]
var currentButtonSet=defaultButtonSet
var useDefaultButtonSet=true;

func changeCollectGameState(newState):
	if collectGameState!=newState:
		collectGameState=newState
		GameEvents.collectGameStateChanged(newState)
