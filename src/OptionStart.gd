extends OptionButton

export (NodePath) onready var boat = get_node(boat) as Boat

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
enum StartPos {Start,OpWater,
  StilleggenOefenening,
  AchteruitvarenOefenening,
  BochtOefenening,
  AchteruitBochtOefenening
  Aanleggen,
  Aangelegd,
  StartStrijkendAanleggen,
  AanleggenWal,
  StartStrijkendAanleggenWal,
  StarGame,
  Intro,
  StartTour,
}

func _ready():
#	add_icon_item(

	add_item("StartPositie",StartPos.Start)
	add_item("StartStilleggenOefenening",StartPos.StilleggenOefenening)
	add_item("StartAchteruitvarenOefenening",StartPos.AchteruitvarenOefenening)
	
	add_item("StartBochtOefenening",StartPos.BochtOefenening)
	add_item("StartAchteruitBochtOefenening",StartPos.AchteruitBochtOefenening)
	
	add_item("StartAanleggen",StartPos.Aanleggen)
	add_item("StartAangelegd",StartPos.Aangelegd)
	add_item("StartStrijkendAanleggen",StartPos.StartStrijkendAanleggen)

	add_item("StartAanleggenWal",StartPos.AanleggenWal)

	add_item("StartStrijkendAanleggenWal",StartPos.StartStrijkendAanleggenWal)

	add_item("StartStarGame",StartPos.StarGame)
	add_item("StartOpWater",StartPos.OpWater)
	add_separator()
	add_item("ShowIntroText",StartPos.Intro)
	add_item("StartTour",StartPos.StartTour)
	
	
	
	connect("item_selected",self,"selected")
	text="StartPositie"

	var pm=get_popup()
	# hide the radio
	for i in pm.get_item_count():
	        if pm.is_item_radio_checkable(i):
	            pm.set_item_as_radio_checkable(i, false)
	#improve style
	var styleDropDown= preload("res://MainDropDownPopup.tres")
	pm.add_stylebox_override("panel",styleDropDown)

	GameEvents.connect("introSignal",self,"_introSignal")
	GameEvents.register_tooltip(self,"OptionStartTooltip")

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
	$"%PracticeStarts".hideAll()
	var forwards=true
	match valueIndex:
		StartPos.OpWater: 
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			callStartPlay=true
		StartPos.StilleggenOefenening:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt]	
			$"%CollectableStopBoatPractice".reset()
			explainPopup.showDialog("StopBoatPracticeExplainText",showOnlyButonsArray)
		StartPos.AchteruitvarenOefenening:
			forwards=false
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden]	
			$"%CollectableBackDownPractice".reset()
			explainPopup.showDialog("BackdownPracticeExplainText",showOnlyButonsArray)
		StartPos.BochtOefenening:
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.SlagklaarAf,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.HalenSB,Constants.Command.HalenBB,Constants.Command.HalenBeideBoorden]	
			$"%CollectableMakeTurnPractice".reset()
			explainPopup.showDialog("TurnPracticeExplainText",showOnlyButonsArray)
		StartPos.AchteruitBochtOefenening:
			forwards=false
			boat.setNewBoatPosition(984.05,1995.76,0,Constants.StateOars.Roeien,true)
			var showOnlyButonsArray =[Constants.Command.LaatLopen,Constants.Command.Bedankt,Constants.Command.StrijkenBeidenBoorden,Constants.Command.VastroeienBeideBoorden,Constants.Command.Bedankt,Constants.Command.StrijkenSB,Constants.Command.StrijkenBB]	
			$"%CollectableBackDownTurnPractice".reset()
			explainPopup.showDialog("BackdownTurnPracticeExplainText",showOnlyButonsArray)
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
	if GameState.isForwards!=forwards:
		GameState.changeForwards(forwards)
	
	if callStartPlay: 
		GameEvents.startPlay()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
