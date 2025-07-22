extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var defaultSettings = ["{}",
"{\"customButtonSet\":[\"SlagklaarAf\",\"LaatLopen,Bedankt,VastroeienBeideBoorden\",\"SlippenBB,Slippen,SlippenSB\",\"\",\"\",\"BakboortBest,BestBedankt,StuurboordBest\",\"PakMaarWeerOp\",\"UitzettenBB,UitzettenSB\",\"\",\"\",\"HalenBB,HalenBeideBoorden,HalenSB\",\"LightPaddle,LightPaddleBedankt\",\"UitbrengenBB,Uitbrengen,UitbrengenSB\",\"\",\"\",\"VastroeienBB,VastroeienBeideBoorden,VastroeienSB\",\"RondmakenBB,RondmakenSB\",\"PeddelendStrijkenBB,PeddelendStrijkenSB\",\"\",\"\",\"StrijkenBB,StrijkenBeidenBoorden,StrijkenSB\",\"RiemenHoogBB,RiemenHoogSB\",\"\",\"\",\"\"],\"language\":\"nl_NL\",\"ruleset\":\"RulesetDefault\",\"showCommandTooltipsOld\":false,\"tooltips\":{},\"translations\":{\"BakboortBest\":\"BB Best\",\"HalenBeideBoorden\":\"Halen\",\"StrijkenBB\":\"BB\",\"StrijkenBeidenBoorden\":\"Strijken\",\"StrijkenSB\":\"SB\",\"StuurboordBest\":\"SB Best\",\"UitbrengenBB\":\"BB\",\"UitbrengenSB\":\"SB\",\"VastroeienBB\":\"BB\",\"VastroeienBeideBoorden\":\"Vastroeien\",\"VastroeienSB\":\"SB\"}}",
"{\"customButtonSet\":[\"SlagklaarAf\",\"LaatLopen,Bedankt,VastroeienBeideBoorden\",\"SlippenBB,Slippen,SlippenSB\",\"\",\"\",\"BakboortBest,BestBedankt,StuurboordBest\",\"PakMaarWeerOp\",\"UitzettenBB,UitzettenSB\",\"\",\"\",\"HalenBB,HalenBeideBoorden,HalenSB\",\"LightPaddle,LightPaddleBedankt\",\"UitbrengenBB,Uitbrengen,UitbrengenSB\",\"\",\"\",\"VastroeienBB,VastroeienBeideBoorden,VastroeienSB\",\"RondmakenBB,RondmakenSB\",\"UitzettenBB,UitzettenSB\",\"\",\"\",\"StrijkenBB,StrijkenBeidenBoorden,StrijkenSB\",\"RiemenHoogBB,RiemenHoogSB\",\"\",\"\",\"\"],\"language\":\"en_US\",\"ruleset\":\"RulesetDefault\",\"showCommandTooltipsOld\":false,\"tooltips\":{\"BakboortBest\":\"Strong port\",\"HalenBB\":\"Stroke port\",\"HalenBeideBoorden\":\"Stroke both sides\",\"HalenSB\":\"stroke SB\",\"SlippenBB\":\"Blades along port side\",\"SlippenSB\":\"Blades along starboard side\",\"StrijkenBB\":\"Back down port\",\"StrijkenSB\":\"Back down starboard\",\"StuurboordBest\":\"Strong starboard\",\"UitbrengenBB\":\"Oat oars port\",\"UitbrengenSB\":\"Out oars starboard\",\"VastroeienBB\":\"Hold port\",\"VastroeienSB\":\"Hold starboard\"},\"translations\":{\"BakboortBest\":\"Strong PO\",\"HalenBB\":\"PO\",\"HalenBeideBoorden\":\"Stroke\",\"HalenSB\":\"SB\",\"SlippenBB\":\"PO\",\"SlippenSB\":\"SB\",\"StrijkenBB\":\"PO\",\"StrijkenSB\":\"SB\",\"StuurboordBest\":\"Strong SB\",\"UitbrengenBB\":\"Out PO\",\"UitbrengenSB\":\"Out SB\",\"VastroeienBB\":\"PO\",\"VastroeienBeideBoorden\":\"Hold\",\"VastroeienSB\":\"SB\"}}",
"{\"customButtonSet\":[\"SlagklaarAf\",\"LaatLopen,Bedankt\",\"VastroeienSB\",\"HalenSB\",\"StrijkenSB\",\"StrijkenBeidenBoorden\",\"VastroeienBeideBoorden\",\"VastroeienBB\",\"HalenBB\",\"StrijkenBB\",\"Slippen\",\"SlippenSB\",\"UitbrengenSB\",\"PeddelendStrijkenSB\",\"RondmakenSB\",\"Uitbrengen\",\"SlippenBB\",\"UitbrengenBB\",\"PeddelendStrijkenBB\",\"RondmakenBB\",\"HalenBeideBoorden\",\"LightPaddle\",\"LightPaddleBedankt\",\"RiemenHoogBB\",\"RiemenHoogSB\"]}",
"{\"customButtonSet\":[\"SlagklaarAf\",\"LaatLopen,Bedankt\",\"VastroeienSB\",\"HalenSB\",\"StrijkenSB\",\"StrijkenBeidenBoorden\",\"VastroeienBeideBoorden\",\"VastroeienBB\",\"HalenBB\",\"StrijkenBB\",\"Slippen\",\"SlippenSB\",\"UitbrengenSB\",\"UitzettenSB\",\"RondmakenSB\",\"Uitbrengen\",\"SlippenBB\",\"UitbrengenBB\",\"UitzettenBB\",\"RondmakenBB\",\"HalenBeideBoorden\",\"LightPaddle\",\"LightPaddleBedankt\",\"RiemenHoogBB\",\"RiemenHoogSB\"]}"
]

# Called when the node enters the scene tree for the first time.
func _ready():
#add_item("ChoosePresetSettings",DefaultSetting.none) 
	add_item("DefaultSettings",0)
	add_item("SettingVikingExtendedShort",1)
	add_item("SettingEnglishExtendedShort",2)
	add_item("SettingVikingOrgineel",3)
	add_item("SettingOriginal",4)
	connect("item_selected",self,"selected")
	resetSelected()
	var font= preload("res://Font.tres")
	var pm=get_popup()
	pm.add_font_override("font",font)	
	#if GameState.mobileMode:
	#	pm.add_constant_override("vseparation",16)

func resetSelected():
	selected=-1	
	text="ChoosePresetSettings"
	
func selected(itemIndex : int):
	
	if itemIndex>=0:
		var newSettings=defaultSettings[itemIndex];
		newSettings=newSettings.percent_decode()
		var settings = parse_json(newSettings)
		$"..".setSettings(settings,true)

		resetSelected()
		$"..".loadTabs()
	
