extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var defaultSettings = ["{}",
"%7B%22customButtonSet%22%3A%5B%22SlagklaarAf%22%2C%22LaatLopen%2CBedankt%2CVastroeienBeideBoorden%22%2C%22SlippenBB%2CSlippen%2CSlippenSB%22%2C%22%22%2C%22%22%2C%22BakboortBest%2CBestBedankt%2CStuurboordBest%22%2C%22PakMaarWeerOp%22%2C%22UitzettenSB%2CUitzettenBB%22%2C%22%22%2C%22%22%2C%22HalenBB%2CHalenBeideBoorden%2CHalenSB%22%2C%22LightPaddle%2CLightPaddleBedankt%22%2C%22UitbrengenBB%2CUitbrengen%2CUitbrengenSB%22%2C%22%22%2C%22%22%2C%22VastroeienBB%2CVastroeienBeideBoorden%2CVastroeienSB%22%2C%22RondmakenBB%2CRondmakenSB%22%2C%22PeddelendStrijkenBB%2CPeddelendStrijkenSB%22%2C%22%22%2C%22%22%2C%22StrijkenBB%2CStrijkenBeidenBoorden%2CStrijkenSB%22%2C%22RiemenHoogBB%2CRiemenHoogSB%22%2C%22UitzettenSB%2CUitzettenBB%22%2C%22%22%2C%22%22%5D%2C%22language%22%3A%22nl_NL%22%2C%22ruleset%22%3A%22RulesetDefault%22%2C%22showCommandTooltips%22%3Afalse%2C%22tooltips%22%3A%7B%7D%2C%22translations%22%3A%7B%22BakboortBest%22%3A%22BB%20Best%22%2C%22HalenBeideBoorden%22%3A%22Halen%22%2C%22StrijkenBB%22%3A%22BB%22%2C%22StrijkenBeidenBoorden%22%3A%22Strijken%22%2C%22StrijkenSB%22%3A%22SB%22%2C%22StuurboordBest%22%3A%22SB%20Best%22%2C%22UitbrengenBB%22%3A%22BB%22%2C%22UitbrengenSB%22%3A%22SB%22%2C%22VastroeienBB%22%3A%22BB%22%2C%22VastroeienBeideBoorden%22%3A%22Vastroeien%22%2C%22VastroeienSB%22%3A%22SB%22%7D%7D",
"%7B%22customButtonSet%22%3A%5B%22SlagklaarAf%22%2C%22LaatLopen%2CBedankt%22%2C%22VastroeienSB%22%2C%22HalenSB%22%2C%22StrijkenSB%22%2C%22StrijkenBeidenBoorden%22%2C%22VastroeienBeideBoorden%22%2C%22VastroeienBB%22%2C%22HalenBB%22%2C%22StrijkenBB%22%2C%22Slippen%22%2C%22SlippenSB%22%2C%22UitbrengenSB%22%2C%22PeddelendStrijkenSB%22%2C%22RondmakenSB%22%2C%22Uitbrengen%22%2C%22SlippenBB%22%2C%22UitbrengenBB%22%2C%22PeddelendStrijkenBB%22%2C%22RondmakenBB%22%2C%22HalenBeideBoorden%22%2C%22LightPaddle%22%2C%22LightPaddleBedankt%22%2C%22RiemenHoogBB%22%2C%22RiemenHoogSB%22%5D%7D",
"%7B%22customButtonSet%22%3A%5B%22SlagklaarAf%22%2C%22LaatLopen%2CBedankt%22%2C%22VastroeienSB%22%2C%22HalenSB%22%2C%22StrijkenSB%22%2C%22StrijkenBeidenBoorden%22%2C%22VastroeienBeideBoorden%22%2C%22VastroeienBB%22%2C%22HalenBB%22%2C%22StrijkenBB%22%2C%22Slippen%22%2C%22SlippenSB%22%2C%22UitbrengenSB%22%2C%22UitzettenSB%22%2C%22RondmakenSB%22%2C%22Uitbrengen%22%2C%22SlippenBB%22%2C%22UitbrengenBB%22%2C%22UitzettenBB%22%2C%22RondmakenBB%22%2C%22HalenBeideBoorden%22%2C%22LightPaddle%22%2C%22LightPaddleBedankt%22%2C%22RiemenHoogBB%22%2C%22RiemenHoogSB%22%5D%7D"
]

# Called when the node enters the scene tree for the first time.
func _ready():
#add_item("ChoosePresetSettings",DefaultSetting.none) 
	add_item("DefaultSettings",0)
	add_item("SettingVikingExtendedShort",1)
	add_item("SettingVikingOrgineel",2)
	add_item("SettingOriginal",3)
	connect("item_selected",self,"selected")
	resetSelected()
	var font= preload("res://Font.tres")
	get_popup().add_font_override("font",font)
	
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

	
