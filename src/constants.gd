extends Node

enum RowState {HalenBeideBoorden,
  LaatLopen,Bedankt,HalenSB,StrijkenSB
  VastroeienSB,StrijkenBeidenBoorden,VastroeienBeideBoorden,
  HalenBB,StrijkenBB,VastroeienBB,
  PeddelendStrijkenBB,PeddelendStrijkenSB,
  UitzettenBB,UitzettenSB,
  RondmakenBB,RondmakenSB
}

enum BestState {Normal,StuurboordBest,BakboordBest}

enum OarsCommand2 {Slippen,Uitbrengen,
  SlippenSB,UitbrengenSB,
  SlippenBB,UitbrengenBB,
  RiemenHoogSB,RiemenHoogBB}

enum StateOars {Roeien,Slippen,SlippenSB,SlippenBB,RiemenHoogSB,RiemenHoogBB}

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
  BestBedankt
}
enum CollectGameState {
	None,
	Start,
	DoStart,
	Finish,
	Finished,
	Crashed,
	Stop
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
  "BestBedankt"
]

enum CommandStyle {StyleButtonGray,StyleButtonDarkGray,StyleButtonSB,StyleButtonBB}


var commandStyles=[
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonDarkGray,
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
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonDarkGray,
CommandStyle.StyleButtonSB,
CommandStyle.StyleButtonBB,
CommandStyle.StyleButtonDarkGray
]

