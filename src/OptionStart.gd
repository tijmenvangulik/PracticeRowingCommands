extends OptionButton


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
		
	add_item(tr("StartPositie"),StartPos.Start)
	add_item(tr("StartStarGame"),StartPos.StarGame)
	add_item(tr("StartOpWater"),StartPos.OpWater)
	add_item(tr("StartAanleggen"),StartPos.Aanleggen)
	add_item(tr("StartAanleggenMinderKnoppen"),StartPos.StartAanleggenMinderKnoppen)
	add_item(tr("StartAangelegd"),StartPos.Aangelegd)
	add_item(tr("StartAangelegdMinderKnoppen"),StartPos.StartAangelegdMinderKnoppen)
	add_item(tr("StartStrijkendAanleggen"),StartPos.StartStrijkendAanleggen)
	add_item(tr("StartStrijkendAanleggenMinderKnoppen"),StartPos.StartStrijkendAanleggenMinderKnoppen)

	add_item(tr("StartAanleggenWal"),StartPos.AanleggenWal)
	add_item(tr("StartAanleggenWalMinderKnoppen"),StartPos.StartAanleggenWalMinderKnoppen)

	add_item(tr("StartStrijkendAanleggenWal"),StartPos.StartStrijkendAanleggenWal)
	add_item(tr("StartStrijkendAanleggenWalMinderKnoppen"),StartPos.StartStrijkendAanleggenWalMinderKnoppen)
	
	add_item(tr("ShowIntroText"),StartPos.Intro)
	
	
	connect("item_selected",self,"selected")
	text=tr("StartPositie")
	pass # Replace with function body.
	

	
func disableCommand(name:String,disabled:bool):
	#"../ButtonsContainer/GridContainer/HalenBeideBoorden"
	#var itemNr=grid.find(name)
	$"../../ButtonsContainer".disableCommand(name,disabled)
	
func showOnlyButtons(var commands):
	
	var boat=$"../../../Boat"
	for commandName in boat.commandNames:
		disableCommand(commandName,len(commands)!=0)
	
	for command in commands:
		disableCommand(boat.commandNames[command],false)
	
func selected(itemIndex : int):
	
	var game=$"../../../Collectables"
	if game.gameStarted:
		game.stopGame()
		
	var valueIndex=get_selected_id()
	var boat=$"../../../Boat"
	boat.resetCrashed()
	var Command=boat.Command
	var isViking=$"../OptionLanguage".isViking
	var showOnlyButonsArray=[]
	match valueIndex:
		StartPos.OpWater: boat.setNewBoatPosition(984.05,1995.76,0,boat.StateOars.Roeien,true)
		StartPos.Aanleggen: 
			boat.setNewBoatPosition(702.307,2145.531,45,boat.StateOars.Roeien,true)
		StartPos.StartAanleggenMinderKnoppen: 
			boat.setNewBoatPosition(831.267,2372.928,45,boat.StateOars.Roeien,true)
			showOnlyButonsArray =[Command.LightPaddle,Command.LightPaddleBedankt,Command.LaatLopen,Command.Bedankt,Command.HalenBeideBoorden,Command.RiemenHoogSB,Command.VastroeienBB]	
		StartPos.Aangelegd: 
			if isViking: 
				boat.setNewBoatPosition(1124,2602,0,boat.StateOars.SlippenSB,true)
			else:
				boat.setNewBoatPosition(1124,2608,0,boat.StateOars.RiemenHoogSB,true)
		StartPos.StartAangelegdMinderKnoppen:
			if isViking: 
				boat.setNewBoatPosition(1124,2602,0,boat.StateOars.SlippenSB,true)
				showOnlyButonsArray =[Command.Bedankt,Command.HalenBeideBoorden,Command.PeddelendStrijkenSB,Command.StrijkenBB,Command.HalenSB,Command.UitbrengenSB]	
			else:
				boat.setNewBoatPosition(1124,2608,0,boat.StateOars.RiemenHoogSB,true)
				showOnlyButonsArray =[Command.Bedankt,Command.HalenBeideBoorden,Command.PeddelendStrijkenSB,Command.HalenSB]	
		StartPos.Intro: $"../../IntroDialog".visible=true
		StartPos.StartStrijkendAanleggen: 
			boat.setNewBoatPosition(1589.091,2426.734,-30,boat.StateOars.Roeien,false)
		StartPos.StartStrijkendAanleggenMinderKnoppen: 
			boat.setNewBoatPosition(1589.091,2426.734,-30,boat.StateOars.Roeien,false)
			showOnlyButonsArray =[Command.LaatLopen,Command.Bedankt,Command.StrijkenBeidenBoorden,Command.RiemenHoogSB,Command.VastroeienBB]	
		StartPos.AanleggenWal: 
			boat.setNewBoatPosition(2082.239,2042.082,-45,boat.StateOars.Roeien,true)
		StartPos.StartAanleggenWalMinderKnoppen: 
			boat.setNewBoatPosition(2082.239,2042.082,-45,boat.StateOars.Roeien,true)
			showOnlyButonsArray =[Command.LightPaddle,Command.LightPaddleBedankt,Command.LaatLopen,Command.Bedankt,Command.HalenBeideBoorden,Command.SlippenSB,Command.VastroeienBB]	
		StartPos.StartStrijkendAanleggenWal: 
			boat.setNewBoatPosition(2220.23,1472.777,-120,boat.StateOars.Roeien,false)
		StartPos.StartStrijkendAanleggenWalMinderKnoppen: 
			boat.setNewBoatPosition(2220.23,1472.777,-120,boat.StateOars.Roeien,false)
			showOnlyButonsArray =[Command.LaatLopen,Command.Bedankt,Command.StrijkenBeidenBoorden,Command.SlippenSB,Command.VastroeienBB]	
		StartPos.StarGame:
			boat.setNewBoatPosition(984.05,1995.76,0,boat.StateOars.Roeien,true)
			$"../../../Collectables".startGame(false)
	showOnlyButtons(showOnlyButonsArray)	
	$"../../OptionCommands".fillDropDown(showOnlyButonsArray)
	select(StartPos.Start)		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
