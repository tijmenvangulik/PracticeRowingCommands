extends Node

enum RowState {HalenBeideBoorden,
  LaatLopen,Bedankt,HalenSB,StrijkenSB
  VastroeienSB,StrijkenBeidenBoorden,VastroeienBeideBoorden,
  HalenBB,StrijkenBB,VastroeienBB,
  PeddelendStrijkenBB,PeddelendStrijkenSB,
  UitzettenBB,UitzettenSB,
  RondmakenBB,RondmakenSB,Roeien,VastroeienSterk
}

enum BestState {Normal,StuurboordBest,BakboordBest}

enum OarsCommand2 {Slippen,Uitbrengen,
  SlippenSB,UitbrengenSB,
  SlippenBB,UitbrengenBB,
  RiemenHoogSB,RiemenHoogBB,IntrekkenSB,IntrekkenBB}

enum StateOars {Roeien,Slippen,SlippenSB,SlippenBB,RiemenHoogSB,RiemenHoogBB,IntrekkenSB,IntrekkenBB}

enum OarWaveState {None,Bedankt,Vastroeien}


enum Command {
  LaatLopen, #0
  Bedankt, #1
  HalenBeideBoorden, #2
  HalenSB, #3
  HalenBB, #4
  StrijkenBeidenBoorden, #5
  StrijkenSB, #6
  StrijkenBB, #7
  VastroeienBeideBoorden, #8
  VastroeienSB, #9
  VastroeienBB, #10
  PeddelendStrijkenSB, #11
  PeddelendStrijkenBB, #12
  UitzettenSB, #13
  UitzettenBB, #14
  RondmakenSB, #15
  RondmakenBB, #16
  Slippen, #17
  SlippenSB, #18
  SlippenBB, #19
  RiemenHoogSB, #20
  RiemenHoogBB, #21
  Uitbrengen, #22
  UitbrengenSB, #23
  UitbrengenBB, #24
  LightPaddle, #25
  LightPaddleBedankt, #26
  StuurboordBest, #27
  BakboortBest, #28
  BestBedankt, #29
  SlagklaarAf, #30
  PakMaarWeerOp, #31
  IntrekkenSB, #32
  IntrekkenBB, #33
  HaalSB, #34
  HaalBB, #35
  StrijkSB, #36
  StrijkBB, #37
  Haal, #38
  Strijk, #39
  VastroeienSterk #40
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
  "Strijk",
  "VastroeienSterk"
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
CommandStyle.StyleButtonGray
]

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
  SpinTurnPractice, #17
  StartModifyPractices, #18
  AanleggenBB, #19
  AangelegdBB, #20
  AangelegdUitzettenBB, #21
  MoringHarbourBB, #22
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
  "SpinTurnPracticeExplainText",#SpinTurnPractice #17
  "", #StartModifyPractices #18
  "MoringBBExplainRaftText", #19
  "SailAwayBBExplainText", #20
  "SailAwayExplainPushAwayBBText", #21
  "MoringHarbourBBExplainText",#MoringHarbour, #22
]
const serverUrl="https://ergometer-space.org/manager"
#const serverUrl="http://localhost:2024"
