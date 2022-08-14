extends Node

var isViking=true
var isForwards=true

var collectGameState= Constants.CollectGameState.None

var collectGameLastTimeString =""
var collectGameIsHighScore=false
var publicHighScorePositon=0
var publicHighscores = []

var defaultButtonSet=["SlagklaarAf","LaatLopen,Bedankt","VastroeienSB","HalenSB","StrijkenSB","StrijkenBeidenBoorden","VastroeienBeideBoorden","VastroeienBB","HalenBB","StrijkenBB","Slippen","SlippenSB","UitbrengenSB","UitzettenSB","RondmakenSB","Uitbrengen","SlippenBB","UitbrengenBB","UitzettenBB","RondmakenBB","HalenBeideBoorden","LightPaddle","LightPaddleBedankt","RiemenHoogSB","RiemenHoogBB"]
var currentButtonSet=defaultButtonSet
var useDefaultButtonSet=true;

func changeCollectGameState(newState):
	if collectGameState!=newState:
		collectGameState=newState
		GameEvents.collectGameStateChanged(newState)

var showTooltips= false

