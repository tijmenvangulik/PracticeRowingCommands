extends Node

enum RowState {HalenBeideBoorden,
  LaatLopen,Bedankt,HalenSB,StrijkenSB
  VastroeienSB,StrijkenBeidenBoorden,VastroeienBeideBoorden,
  HalenBB,StrijkenBB,VastroeienBB,
  PeddelendStrijkenBB,PeddelendStrijkenSB,
  UitzettenBB,UitzettenSB,
  RondmakenBB,RondmakenSB,Roeien
}

enum BestState {Normal,StuurboordBest,BakboordBest}

enum OarsCommand2 {Slippen,Uitbrengen,
  SlippenSB,UitbrengenSB,
  SlippenBB,UitbrengenBB,
  RiemenHoogSB,RiemenHoogBB,IntrekkenSB,IntrekkenBB}

enum StateOars {Roeien,Slippen,SlippenSB,SlippenBB,RiemenHoogSB,RiemenHoogBB,IntrekkenSB,IntrekkenBB}

enum OarWaveState {None,Bedankt,Vastroeien}


enum Command {
  LaatLopen,
  Bedankt,
  HalenBeideBoorden,
  HalenSB,
  HalenBB,
  StrijkenBeidenBoorden,
  StrijkenSB,
  StrijkenBB,
  VastroeienBeideBoorden,
  VastroeienSB,
  VastroeienBB,
  PeddelendStrijkenSB,
  PeddelendStrijkenBB,
  UitzettenSB,
  UitzettenBB,
  RondmakenSB,
  RondmakenBB,
  Slippen,
  SlippenSB,
  SlippenBB,
  RiemenHoogSB,
  RiemenHoogBB,
  Uitbrengen,
  UitbrengenSB,
  UitbrengenBB,
  LightPaddle,
  LightPaddleBedankt,
  StuurboordBest,
  BakboortBest,
  BestBedankt,
  SlagklaarAf,
  PakMaarWeerOp,
  IntrekkenSB,
  IntrekkenBB,
  HaalSB,
  HaalBB,
  StrijkSB,
  StrijkBB,
  Haal,
  Strijk
}
enum CollectGameState {
	None,
	ShowHighScores,
	Start,
	DoStart,
	Finish,
	Finished,
	Crashed,
	Stop
}
enum BoatType {
	Default,
	Scull,
	Sweep
}
var commandNames = [
  "LaatLopen",
  "Bedankt",
  "HalenBeideBoorden",
  "HalenSB",
  "HalenBB",
  "StrijkenBeidenBoorden",
  "StrijkenSB",
  "StrijkenBB",
  "VastroeienBeideBoorden",
  "VastroeienSB",
  "VastroeienBB",
  "PeddelendStrijkenSB",
  "PeddelendStrijkenBB",
  "UitzettenSB",
  "UitzettenBB",
  "RondmakenSB",
  "RondmakenBB",
  "Slippen",
  "SlippenSB",
  "SlippenBB",
  "RiemenHoogSB",
  "RiemenHoogBB",
  "Uitbrengen",
  "UitbrengenSB",
  "UitbrengenBB",
  "LightPaddle",
  "LightPaddleBedankt",
  "StuurboordBest",
  "BakboortBest",
  "BestBedankt",
  "SlagklaarAf",
  "PakMaarWeerOp",
  "IntrekkenSB",
  "IntrekkenBB",
  "HaalSB",
  "HaalBB",
  "StrijkSB",
  "StrijkBB",
  "Haal",
  "Strijk"
]

enum CommandStyle {StyleButtonGray,StyleButtonDarkGray,StyleButtonSB,StyleButtonBB}


var commandStyles=[
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonDarkGray,
]

#const languageItems=["NL Viking","EN Viking","Nederlands","English","English 2"]
const sharedSettingLangKey= "custom"
var languageKeys=["nl_NL","en_BW","nl","en","en_US","nl_AW"]
var urlKeys=["nl_viking","en_viking","nl","en","en2","nl_hemus"]
var flags=["nl_viking","gb_viking","nl","gb","gb","nl_hemus"]
var languageLongItems=["Nederlands / Viking","English / Viking (dutch commands)","Nederlands / Generiek","English / Generic 1","English / Generic 2","Nederlands / Hemus"]

const english2Config="{\"tooltips\":{},\"language\":\"en\",\"translations\":{\"BakboortBest\":\"Strong port\",\"HaalBB\":\"1 Stroke port\",\"HaalSB\":\"1 Stroke starboard\",\"HalenBB\":\"Stroke port\",\"HalenSB\":\"Stroke starboard\",\"IntrekkenBB\":\"Pull in port\",\"IntrekkenSB\":\"Pull in starboard\",\"PeddelendStrijkenBB\":\"Along side back down port\",\"PeddelendStrijkenSB\":\"Along side back down starbard\",\"RiemenHoogBB\":\"Oars hight port\",\"RiemenHoogSB\":\"Oars hight starboard\",\"RondmakenBB\":\"Spin turn port\",\"RondmakenSB\":\"Spin turn starboard\",\"SlippenBB\":\"Blades along port\",\"SlippenSB\":\"Blades along starboard\",\"StrijkBB\":\"1 Back down port\",\"StrijkSB\":\"1 Back down starboard\",\"StrijkenBB\":\"Back down port\",\"StrijkenSB\":\"Back down starboard\",\"StuurboordBest\":\"Strong starboard\",\"UitbrengenBB\":\"Out oars port\",\"UitbrengenSB\":\"Out oars starboard\",\"UitzettenBB\":\"Push away port\",\"UitzettenSB\":\"Push away starboard\",\"VastroeienBB\":\"Hold port\",\"VastroeienSB\":\"Hold starboard\"}}"
var baseConfigs=["","","","",english2Config,""]

enum DefaultYesNo {
	Default,
	Yes,
	No
}
enum CollectableSpriteStyle {
	Game,
	Practice,
	PracticeCollected
}

# never change the order of these enums
enum StartItem {
  StartTour,  #0
  StilleggenOefenening, #1
  BochtOefenening, #2
  AchteruitvarenOefenening, #3
  AchteruitBochtOefenening #4
  Aanleggen, #5
  Aangelegd, #6
  StartStrijkendAanleggen, #7
  AanleggenWal, #8
  StartStrijkendAanleggenWal, #9
  StarGame, #10
  Start, #11
  Intro, #12
  MoringHarbour, #13
  SlalomPractice, #14
  BridgePractice, #15
  AangelegdUitzetten, #16
  SpinTurnPractice #17
}

var practiceExplainTexts= [
  "",#StartTour,  #0
  "StopBoatPracticeExplainText",#StilleggenOefenening, #1
  "TurnPracticeExplainText",#BochtOefenening, #2
  "BackdownPracticeExplainText",#AchteruitvarenOefenening, #3
  "BackdownTurnPracticeExplainText",#AchteruitBochtOefenening #4
  "MoringExplainRaftText",#Aanleggen, #5
  "SailAwayExplainText",#Aangelegd, #6
  "BackwardsMoringRaftExplainText",#StartStrijkendAanleggen, #7
  "MoringExplainText",#AanleggenWal, #8
  "BackwardsMoringExplainText",#StartStrijkendAanleggenWal, #9
  "",#StarGame, #10
  "",#Start, #11
  "",#Intro, #12
  "MoringHarbourExplainText",#MoringHarbour, #13
  "StartSlalomPracticeExplainText",#SlalomPractice, #14
  "BridgeExplainText",#BridgePractice, #15
  "SailAwayExplainPushAwayText",#AangelegdUitzetten #16
  "SpinTurnPracticeExplainText"#SpinTurnPractice #17
]
const serverUrl="https://ergometer-space.org/manager"
#const serverUrl="http://localhost:2024"
