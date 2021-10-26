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
  StartStrijkendAanleggenWalMinderKnoppen
}

func _ready():
		
	add_item(tr("StartPositie"),StartPos.Start)
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
	var item=$"../ButtonsContainer/GridContainer".find_node(name,true,false)
	if item!=null:
		item.disabled=disabled
		
func showOnlyButtons(var commands):
	
	var boat=$"../../Boat"
	for commandName in boat.commandNames:
		disableCommand(commandName,len(commands)!=0)
	
	for command in commands:
		disableCommand(boat.commandNames[command],false)
	
func selected(itemIndex : int):
	var valueIndex=get_selected_id()
	var boat=$"../../Boat"
	var Command=boat.Command
	var isViking=$"../OptionLanguage".isViking
	var showOnlyButonsArray=[]
	match valueIndex:
		StartPos.OpWater: boat.setNewBoatPosition(1100.95,2008.65,0,boat.StateOars.Roeien)
		StartPos.Aanleggen: 
			boat.setNewBoatPosition(702.307,2145.531,45,boat.StateOars.Roeien)
		StartPos.StartAanleggenMinderKnoppen: 
			boat.setNewBoatPosition(831.267,2372.928,45,boat.StateOars.Roeien)
			showOnlyButonsArray =[Command.LightPaddle,Command.LightPaddleBedankt,Command.LaatLopen,Command.Bedankt,Command.HalenBeideBoorden,Command.RiemenHoogSB,Command.VastroeienBB]	
		StartPos.Aangelegd: 
			var newOars=boat.StateOars.RiemenHoogSB
			if isViking: newOars=boat.StateOars.SlippenSB
			boat.setNewBoatPosition(1129.599,2610,0,newOars)
		StartPos.StartAangelegdMinderKnoppen:
			var newOars=boat.StateOars.RiemenHoogSB
			if isViking: newOars=boat.StateOars.SlippenSB
			boat.setNewBoatPosition(1129.599,2610,0,newOars)
			if isViking: 
				showOnlyButonsArray =[Command.Bedankt,Command.HalenBeideBoorden,Command.PeddelendStrijkenSB,Command.StrijkenBB,Command.HalenSB,Command.UitbrengenSB]	
			else:
				showOnlyButonsArray =[Command.Bedankt,Command.HalenBeideBoorden,Command.PeddelendStrijkenSB,Command.HalenSB]	
		StartPos.Intro: $"../IntroDialog".visible=true
		StartPos.StartStrijkendAanleggen: 
			boat.setNewBoatPosition(1589.091,2426.734,-30,boat.StateOars.Roeien)
		StartPos.StartStrijkendAanleggenMinderKnoppen: 
			boat.setNewBoatPosition(1589.091,2426.734,-30,boat.StateOars.Roeien)
			showOnlyButonsArray =[Command.LaatLopen,Command.Bedankt,Command.StrijkenBeidenBoorden,Command.RiemenHoogSB,Command.VastroeienBB]	
		StartPos.AanleggenWal: 
			boat.setNewBoatPosition(2082.239,2042.082,-45,boat.StateOars.Roeien)
		StartPos.StartAanleggenWalMinderKnoppen: 
			boat.setNewBoatPosition(2082.239,2042.082,-45,boat.StateOars.Roeien)
			showOnlyButonsArray =[Command.LightPaddle,Command.LightPaddleBedankt,Command.LaatLopen,Command.Bedankt,Command.HalenBeideBoorden,Command.SlippenSB,Command.VastroeienBB]	
		StartPos.StartStrijkendAanleggenWal: 
			boat.setNewBoatPosition(2220.23,1472.777,-120,boat.StateOars.Roeien)
		StartPos.StartStrijkendAanleggenWalMinderKnoppen: 
			boat.setNewBoatPosition(2220.23,1472.777,-120,boat.StateOars.Roeien)
			showOnlyButonsArray =[Command.LaatLopen,Command.Bedankt,Command.StrijkenBeidenBoorden,Command.SlippenSB,Command.VastroeienBB]	
		
	showOnlyButtons(showOnlyButonsArray)	
	$"../OptionCommands".fillDropDown(showOnlyButonsArray)
	select(StartPos.Start)		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
