extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var defaultSettings = ["{}",
"%7B%22customButtonSet%22%3A%5B%22BakboortBest%2CBestBedankt%2CStuurboordBest%22%2C%22LightPaddle%22%2C%22UitzettenBB%2CUitzettenSB%22%2C%22%22%2C%22%22%2C%22HalenBB%2CHalenBeideBoorden%2CHalenSB%22%2C%22LightPaddleBedankt%22%2C%22UitbrengenBB%2CUitbrengen%2CUitbrengenSB%22%2C%22%22%2C%22%22%2C%22SlagklaarAf%2CLaatLopen%2CBedankt%22%2C%22PakMaarWeerOp%22%2C%22SlippenBB%2CSlippen%2CSlippenSB%22%2C%22%22%2C%22%22%2C%22VastroeienBB%2CVastroeienBeideBoorden%2CVastroeienSB%22%2C%22%22%2C%22RiemenHoogBB%2CRiemenHoogSB%22%2C%22%22%2C%22%22%2C%22StrijkenBB%2CStrijkenBeidenBoorden%2CStrijkenSB%2CRondmakenBB%2CRondmakenSB%22%2C%22%22%2C%22PeddelendStrijkenBB%2CPeddelendStrijkenSB%22%2C%22%22%2C%22%22%5D%2C%22language%22%3A%22nl_NL%22%2C%22ruleset%22%3A%22RulesetDefault%22%2C%22showCommandTooltips%22%3Atrue%2C%22tooltips%22%3A%7B%22HalenBB%22%3A%22Halen%20BB%22%2C%22HalenBeideBoorden%22%3A%22Halen%20beide%20boorden%22%2C%22HalenSB%22%3A%22Halen%20SB%22%2C%22PeddelendStrijkenSB%22%3A%22Peddelend%20strijken%20SB%22%2C%22RiemenHoogSB%22%3A%22Riemen%20hoog%20SB%22%2C%22RondmakenSB%22%3A%22Rondmaken%20over%20SB%22%2C%22SlippenBB%22%3A%22Slippen%20BB%22%2C%22SlippenSB%22%3A%22Slippen%20SB%22%2C%22StrijkenBB%22%3A%22Strijken%20BB%22%2C%22StrijkenBeidenBoorden%22%3A%22Strijken%20beide%20boorden%22%2C%22StrijkenSB%22%3A%22Strijken%20SB%22%2C%22UitbrengenBB%22%3A%22Uitbrengen%20BB%22%2C%22UitbrengenSB%22%3A%22Uitbrengen%20SB%22%2C%22VastroeienBB%22%3A%22Vastroeien%20BB%22%2C%22VastroeienBeideBoorden%22%3A%22Vastroeien%20beide%20boorden%22%2C%22VastroeienSB%22%3A%22Vastroeien%20SB%22%7D%2C%22translations%22%3A%7B%22HalenBB%22%3A%22BB%22%2C%22HalenBeideBoorden%22%3A%22Halen%22%2C%22HalenSB%22%3A%22SB%22%2C%22PeddelendStrijkenSB%22%3A%22SB%22%2C%22RiemenHoogSB%22%3A%22SB%22%2C%22RondmakenSB%22%3A%22over%20SB%22%2C%22SlippenBB%22%3A%22BB%22%2C%22SlippenSB%22%3A%22SB%22%2C%22StrijkenBB%22%3A%22BB%22%2C%22StrijkenBeidenBoorden%22%3A%22Strijken%22%2C%22StrijkenSB%22%3A%22SB%22%2C%22UitbrengenBB%22%3A%22BB%22%2C%22UitbrengenSB%22%3A%22SB%22%2C%22VastroeienBB%22%3A%22BB%22%2C%22VastroeienBeideBoorden%22%3A%22Vastroeien%22%2C%22VastroeienSB%22%3A%22SB%22%7D%2C%22zoom%22%3A2.881202%7D"]
enum DefaultSetting {default,vikingNLExtendedShort}

# Called when the node enters the scene tree for the first time.
func _ready():
#add_item("ChoosePresetSettings",DefaultSetting.none) 
	add_item("DefaultSettings",DefaultSetting.default)
	add_item("SettingVikingExtendedShort",DefaultSetting.vikingNLExtendedShort)
	connect("item_selected",self,"selected")
	resetSelected()
	
func resetSelected():
	selected=-1	
	text="ChoosePresetSettings"
	
func selected(itemIndex : int):
	
	if itemIndex>=DefaultSetting.default:
		var newSettings=defaultSettings[itemIndex];
		newSettings=newSettings.percent_decode()
		var settings = parse_json(newSettings)
		$"..".setSettings(settings,true)

		resetSelected()

	
