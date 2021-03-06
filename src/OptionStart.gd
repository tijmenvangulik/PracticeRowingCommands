extends OptionButton

export (NodePath) onready var boat = get_node(boat) as Boat

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
enum StartPos {Start,OpWater,
  Aanleggen,
  StartAanleggenMinderKnoppen,
  Aangelegd,
  Intro,
  StartAangelegdMinderKnoppen,
  AanleggenWal,
  StartAanleggenWalMinderKnoppen,
  StartStrijkendAanleggen,
  StartStrijkendAanleggenMinderKnoppen
  StartStrijkendAanleggenWal,
  StartStrijkendAanleggenWalMinderKnoppen,
  StarGame
}

func _ready():
		
	add_item("StartPositie",StartPos.Start)
	add_item("StartStarGame",StartPos.StarGame)
	add_item("StartOpWater",StartPos.OpWater)
	add_item("StartAanleggen",StartPos.Aanleggen)
	add_item("StartAanleggenMinderKnoppen",StartPos.StartAanleggenMinderKnoppen)
	add_item("StartAangelegd",StartPos.Aangelegd)
	add_item("StartAangelegdMinderKnoppen",StartPos.StartAangelegdMinderKnoppen)
	add_item("StartStrijkendAanleggen",StartPos.StartStrijkendAanleggen)
	add_item("StartStrijkendAanleggenMinderKnoppen",StartPos.StartStrijkendAanleggenMinderKnoppen)

	add_item("StartAanleggenWal",StartPos.AanleggenWal)
	add_item("StartAanleggenWalMinderKnoppen",StartPos.StartAanleggenWalMinderKnoppen)

	add_item("StartStrijkendAanleggenWal",StartPos.StartStrijkendAanleggenWal)
	add_item("StartStrijkendAanleggenWalMinderKnoppen",StartPos.StartStrijkendAanleggenWalMinderKnoppen)
	
	add_item("ShowIntroText",StartPos.Intro)
	
	
	connect("item_selected",self,"selected")
	text="StartPositie"
	
	var styleDropDown= preload("res://MainDropDown.tres")
	get_popup().add_stylebox_override("panel",styleDropDown)


	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_tooltip(self,"OptionStartTooltip")

func _introSignal(isVisible : bool):
	visible=!isVisible
	
func disableCommand(name:String,disabled:bool):
	#"../ButtonsContainer/GridContainer/HalenBeideBoorden"
	#var itemNr=grid.find(name)
	GameEvents.disableCommand(name,disabled)
	
func showOnlyButtons(var commands):
	
	for commandName in Constants.commandNames:
		disableCommand(commandName,len(commands)!=0)
	
	for command in commands:
		disableCommand(Constants.commandNames[command],false)
	
func selected(itemIndex : int):
	
	if GameState.collectGameState!=Constants.CollectGameState.None:
		GameState.changeCollectGameState(Constants.CollectGameState.Stop)
		
	var valueIndex=get_selected_id()
	boat.resetCrashed()
	var Command=Constants.Command
	var isViking=GameState.isViking
	var showOnlyButonsArray=[]
	match valueIndex:
		StartPos.OpWater: boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
		StartPos.Aanleggen: 
			boat.setNewBoatPosition(702.307,2145.531,45,Constants.StateOars.Roeien,true)
		StartPos.StartAanleggenMinderKnoppen: 
			boat.setNewBoatPosition(831.267,2372.928,45,Constants.StateOars.Roeien,true)
			showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienBB]	
		StartPos.Aangelegd: 
			if isViking: 
				boat.setNewBoatPosition(1124,2602,0,Constants.StateOars.SlippenSB,true)
			else:
				boat.setNewBoatPosition(1124,2608,0,Constants.StateOars.RiemenHoogSB,true)
		StartPos.StartAangelegdMinderKnoppen:
			if isViking: 
				boat.setNewBoatPosition(1124,2602,0,Constants.StateOars.SlippenSB,true)
				showOnlyButonsArray =[Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.PeddelendStrijkenSB,Constants.Command.StrijkenBB,Constants.Command.HalenSB,Constants.Command.UitbrengenSB]	
			else:
				boat.setNewBoatPosition(1124,2608,0,Constants.StateOars.RiemenHoogSB,true)
				showOnlyButonsArray =[Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.HalenSB,Constants.Command.UitzettenSB]	
		StartPos.Intro: GameEvents.intro(true)
		StartPos.StartStrijkendAanleggen: 
			boat.setNewBoatPosition(1589.091,2426.734,-30,Constants.StateOars.Roeien,false)
		StartPos.StartStrijkendAanleggenMinderKnoppen: 
			boat.setNewBoatPosition(1589.091,2426.734,-30,Constants.StateOars.Roeien,false)
			showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienBB]	
		StartPos.AanleggenWal: 
			boat.setNewBoatPosition(2082.239,2042.082,-45,Constants.StateOars.Roeien,true)
		StartPos.StartAanleggenWalMinderKnoppen: 
			boat.setNewBoatPosition(2082.239,2042.082,-45,Constants.StateOars.Roeien,true)
			showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.SlippenSB,Constants.Command.VastroeienBB]	
		StartPos.StartStrijkendAanleggenWal: 
			boat.setNewBoatPosition(2220.23,1472.777,-120,Constants.StateOars.Roeien,false)
		StartPos.StartStrijkendAanleggenWalMinderKnoppen: 
			boat.setNewBoatPosition(2220.23,1472.777,-120,Constants.StateOars.Roeien,false)
			showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.SlippenSB,Constants.Command.VastroeienBB]	
		StartPos.StarGame:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			GameState.changeCollectGameState(Constants.CollectGameState.Start)

	showOnlyButtons(showOnlyButonsArray)	
	GameEvents.commandsChanged(showOnlyButonsArray)
	select(StartPos.Start)		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
