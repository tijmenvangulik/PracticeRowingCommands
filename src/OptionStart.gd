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
  StarGame,
  StartTour
}

func _ready():
#	add_icon_item(
	add_item("StartPositie",StartPos.Start)
	add_item("StartOpWater",StartPos.OpWater)
	add_item("StartAanleggen",StartPos.Aanleggen)
	add_item("StartAangelegd",StartPos.Aangelegd)
	add_item("StartStrijkendAanleggen",StartPos.StartStrijkendAanleggen)

	add_item("StartAanleggenWal",StartPos.AanleggenWal)

	add_item("StartStrijkendAanleggenWal",StartPos.StartStrijkendAanleggenWal)

	add_item("StartStarGame",StartPos.StarGame)
	
	add_separator()
	add_item("ShowIntroText",StartPos.Intro)
	add_item("StartTour",StartPos.StartTour)
#	add_separator()
	
	
	connect("item_selected",self,"selected")
	text="StartPositie"
	
	var styleDropDown= preload("res://MainDropDownPopup.tres")
	get_popup().add_stylebox_override("panel",styleDropDown)


	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_allways_tooltip(self,"OptionStartTooltip")

func _introSignal(isVisible : bool):
	visible=!isVisible
	

	
func selected(itemIndex : int):
	
	if GameState.collectGameState!=Constants.CollectGameState.None:
		GameState.changeCollectGameState(Constants.CollectGameState.Stop)
		
	var valueIndex=get_selected_id()
	boat.resetCrashed()
	var Command=Constants.Command
	var isViking=GameState.isViking
	
	var explainPopup=$"%ExplainPracticeDialog"
	var callStartPlay=false
	
	Utilities.showOnlyButtons([])

	match valueIndex:
		StartPos.OpWater: 
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			callStartPlay=true
		StartPos.Aanleggen:
			boat.setNewBoatPosition(702.307,2145.531,45,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienBB]	
			explainPopup.showDialog("MoringExplainRaftText",showOnlyButonsArray)
		StartPos.Aangelegd:
			var showOnlyButonsArray=[]
			if isViking: 
				boat.setNewBoatPosition(1124,2596,0,Constants.StateOars.SlippenSB,true)
				showOnlyButonsArray =[Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.PeddelendStrijkenSB,Constants.Command.StrijkenBB,Constants.Command.HalenSB,Constants.Command.UitbrengenSB]	
			else:
				boat.setNewBoatPosition(1124,2608,0,Constants.StateOars.RiemenHoogSB,true)
				showOnlyButonsArray =[Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.HalenSB,Constants.Command.UitzettenSB]	
			explainPopup.showDialog("SailAwayExplainText",showOnlyButonsArray)
		StartPos.Intro: GameEvents.intro(true)
		StartPos.StartTour: GameEvents.startTour()
		StartPos.StartStrijkendAanleggen: 
			boat.setNewBoatPosition(1589.091,2426.734,-30,Constants.StateOars.Roeien,false)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.RiemenHoogSB,Constants.Command.VastroeienBB]	
			explainPopup.showDialog("BackwardsMoringRaftExplainText",showOnlyButonsArray)
		StartPos.AanleggenWal: 
			boat.setNewBoatPosition(2082.239,2042.082,-45,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LightPaddle,Constants.Command.LightPaddleBedankt,Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.SlippenSB,Constants.Command.VastroeienBB,Constants.Command.IntrekkenSB]	
			explainPopup.showDialog("MoringExplainText",showOnlyButonsArray)
		StartPos.StartStrijkendAanleggenWal: 
			boat.setNewBoatPosition(2220.23,1472.777,-120,Constants.StateOars.Roeien,false)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.SlippenSB,Constants.Command.VastroeienBB,Constants.Command.IntrekkenSB]	
			explainPopup.showDialog("BackwardsMoringExplainText",showOnlyButonsArray)
		StartPos.StarGame:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			GameState.changeCollectGameState(Constants.CollectGameState.ShowHighScores)
	
	select(StartPos.Start)
	if callStartPlay: 
		GameEvents.startPlay()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
