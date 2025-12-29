extends Node

# key: an uniqe identifier. when baseConfig is empty it should be a godot language code. 
#      The godot language is set to this key. When there is a baseConfig the key can be any value as long as it is not "custom"
# urlKey : the key used in the url
# flag : same as the flag resource name
# displayName : name in the selection box when started for the first time
# baseConfig : the base config, first it looks at the config defined by the language resource and it adds the settings of the base config
const initalSettings = [
	{
		"key": "nl_NL",
		"urlKey": "nl_viking",
		"flag":"nl_viking",
		"displayName":"Nederlands / Viking",
		"baseConfig":""
	},
	{
		"key": "en_BW",
		"urlKey": "en_viking",
		"flag":"gb_viking",
		"displayName":"English / Viking (dutch commands)",
		"baseConfig":""
	},
	{
		"key": "nl",
		"urlKey": "nl",
		"flag":"nl",
		"displayName":"Nederlands / Generiek",
		"baseConfig":""
	},
	{
		"key": "en",
		"urlKey": "en",
		"flag":"gb",
		"displayName":"English / Generic sweep",
		"baseConfig":"{\"boatType\":2,\"language\":\"en\"}"
	},
	{
		"key": "en_US",
		"urlKey": "en2",
		"flag":"gb",
		"displayName":"English / Generic scull",
		"baseConfig":"{\"boatType\":1,\"tooltips\":{},\"language\":\"en\",\"translations\":{\"BakboortBest\":\"Strong port\",\"HaalBB\":\"1 Stroke port\",\"HaalSB\":\"1 Stroke starboard\",\"HalenBB\":\"Stroke port\",\"HalenSB\":\"Stroke starboard\",\"IntrekkenBB\":\"Pull in port\",\"IntrekkenSB\":\"Pull in starboard\",\"PeddelendStrijkenBB\":\"Along side back down port\",\"PeddelendStrijkenSB\":\"Along side back down starbard\",\"RiemenHoogBB\":\"Oars high port\",\"RiemenHoogSB\":\"Oars high starboard\",\"RondmakenBB\":\"Spin turn port\",\"RondmakenSB\":\"Spin turn starboard\",\"SlippenBB\":\"Blades along port\",\"SlippenSB\":\"Blades along starboard\",\"StrijkBB\":\"1 Back down port\",\"StrijkSB\":\"1 Back down starboard\",\"StrijkenBB\":\"Back down port\",\"StrijkenSB\":\"Back down starboard\",\"StuurboordBest\":\"Strong starboard\",\"UitbrengenBB\":\"Out oars port\",\"UitbrengenSB\":\"Out oars starboard\",\"UitzettenBB\":\"Push away port\",\"UitzettenSB\":\"Push away starboard\",\"VastroeienBB\":\"Hold port\",\"VastroeienSB\":\"Hold starboard\"},\"textTranslations\":{\"BakboortBest\":\"Strong port\",\"HaalBB\":\"1 Stroke port\",\"HaalSB\":\"1 Stroke starboard\",\"HalenBB\":\"Stroke port\",\"HalenSB\":\"Stroke starboard\",\"IntrekkenBB\":\"Pull in port\",\"IntrekkenSB\":\"Pull in starboard\",\"PeddelendStrijkenBB\":\"Along side back down port\",\"PeddelendStrijkenSB\":\"Along side back down starbard\",\"RiemenHoogBB\":\"Oars high port\",\"RiemenHoogSB\":\"Oars high starboard\",\"RondmakenBB\":\"Spin turn port\",\"RondmakenSB\":\"Spin turn starboard\",\"SlippenBB\":\"Blades along port\",\"SlippenSB\":\"Blades along starboard\",\"StrijkBB\":\"1 Back down port\",\"StrijkSB\":\"1 Back down starboard\",\"StrijkenBB\":\"Back down port\",\"StrijkenSB\":\"Back down starboard\",\"StuurboordBest\":\"Strong starboard\",\"UitbrengenBB\":\"Out oars port\",\"UitbrengenSB\":\"Out oars starboard\",\"UitzettenBB\":\"Push away port\",\"UitzettenSB\":\"Push away starboard\",\"VastroeienBB\":\"Hold port\",\"VastroeienSB\":\"Hold starboard\"}}"
	},
	{
		"key": "nl_AW",
		"urlKey": "nl_hemus",
		"flag":"nl_hemus",
		"displayName":"Nederlands / Hemus",
		"baseConfig":"{\"boatType\":0,\"customButtonSet\":[\"SlagklaarAf\",\"LaatLopen,Bedankt,VastroeienBeideBoorden\",\"SlippenBB,Slippen,SlippenSB\",\"\",\"\",\"BakboortBest,BestBedankt,StuurboordBest\",\"PakMaarWeerOp\",\"UitzettenBB,UitzettenSB\",\"\",\"\",\"HalenBB,HalenBeideBoorden,HalenSB\",\"LightPaddle,LightPaddleBedankt\",\"UitbrengenBB,Uitbrengen,UitbrengenSB\",\"\",\"\",\"VastroeienBB,VastroeienBeideBoorden,VastroeienSB\",\"RondmakenBB,RondmakenSB\",\"PeddelendStrijkenBB,PeddelendStrijkenSB\",\"\",\"\",\"StrijkenBB,StrijkenBeidenBoorden,StrijkenSB\",\"RiemenHoogBB,RiemenHoogSB\",\"\",\"\",\"\"],\"disabledPractices\":[13,19,20,21,22],\"disabledPracticesUseDefault\":false,\"isScull\":true,\"language\":\"nl\",\"name\":\"Hemus\",\"practiceExplainTranslations\":[],\"practiceTranslations\":[],\"ruleset\":\"RulesetDefault\",\"shortcuts\":{},\"showCommandTooltips\":false,\"showShortCutsInButtons\":false,\"textTranslations\":{\"BakboortBest\":\"Bakboord best\",\"LightPaddle\":\"Light paddle\",\"LightPaddleBedankt\":\"Light paddle bedankt\",\"PeddelendStrijkenBB\":\"Slippend strijken BB\",\"PeddelendStrijkenSB\":\"Slippend strijken SB\",\"StrijkenBeidenBoorden\":\"Strijken\",\"StuurboordBest\":\"Stuurboord sterk\",\"VastroeienBB\":\"Vastroeien BB\",\"VastroeienBeideBoorden\":\"Vastroeien\",\"VastroeienSB\":\"Vastroeien SB\"},\"tooltips\":{},\"translations\":{\"BakboortBest\":\"BB Best\",\"HalenBeideBoorden\":\"Halen\",\"LightPaddle\":\"Light paddle\",\"LightPaddleBedankt\":\"Light paddle bedankt\",\"PeddelendStrijkenBB\":\"Slippend strijken BB\",\"PeddelendStrijkenSB\":\"Slippend strijken SB\",\"StrijkenBB\":\"BB\",\"StrijkenBeidenBoorden\":\"Strijken\",\"StrijkenSB\":\"SB\",\"StuurboordBest\":\"SB Sterk\",\"UitbrengenBB\":\"BB\",\"UitbrengenSB\":\"SB\",\"VastroeienBB\":\"BB\",\"VastroeienBeideBoorden\":\"Vastroeien\",\"VastroeienSB\":\"SB\"}}"
	},
	{
		"key": "nl_BWV_DE_EEM",
		"urlKey": "nl_bwv_de_eem",
		"flag":"nl_BWV_de_eem",
		"displayName":"Nederlands / BWV de Eem",
		"baseConfig":"{\"boatType\":0,\"customButtonSet\":[\"SlagklaarAf\",\"LaatLopen,Bedankt,VastroeienBeideBoorden\",\"SlippenBB,Slippen,SlippenSB\",\"\",\"\",\"BakboortBest,BestBedankt,StuurboordBest\",\"PakMaarWeerOp\",\"RiemenHoogBB,RiemenHoogSB\",\"\",\"\",\"HalenBB,HalenBeideBoorden,HalenSB\",\"LightPaddle,LightPaddleBedankt\",\"UitbrengenBB,Uitbrengen,UitbrengenSB\",\"\",\"\",\"VastroeienBB,VastroeienBeideBoorden,VastroeienSB\",\"RondmakenBB,RondmakenSB\",\"PeddelendStrijkenBB,PeddelendStrijkenSB\",\"\",\"\",\"StrijkenBB,StrijkenBeidenBoorden,StrijkenSB\",\"VastroeienSterk\",\"UitzettenBB,UitzettenSB\",\"\",\"\"],\"disabledPractices\":[13,19,20,21,22],\"disabledPracticesUseDefault\":true,\"isScull\":true,\"language\":\"nl\",\"name\":\"BWV de Eem\",\"practiceExplainTranslations\":[],\"practiceTranslations\":[],\"ruleset\":\"RulesetDefault\",\"shortcuts\":{},\"showCommandTooltips\":false,\"showShortCutsInButtons\":false,\"textTranslations\":{\"BakboortBest\":\"Bakboord best\",\"LightPaddle\":\"Light paddle\",\"LightPaddleBedankt\":\"Light paddle bedankt\",\"PeddelendStrijkenBB\":\"Slippend strijken BB\",\"PeddelendStrijkenSB\":\"Slippend strijken SB\",\"RiemenHoogBB\":\"Overhellen waterzijde (SB)\",\"RiemenHoogSB\":\"Overhellen waterzijde (BB)\",\"RondmakenBB\":\"Ronden SB\",\"RondmakenSB\":\"Ronden SB\",\"StrijkenBeidenBoorden\":\"Strijken\",\"StuurboordBest\":\"Stuurboord sterk\",\"VastroeienBB\":\"Vastroeien BB\",\"VastroeienBeideBoorden\":\"Vastroeien\",\"VastroeienSB\":\"Vastroeien SB\",\"VastroeienSterk\":\"Houden!\"},\"tooltips\":{\"RondmakenBB\":\"Klaarmaken om te ronden over SB, Ronden Nu!\",\"RondmakenSB\":\"Klaarmaken om te ronden over SB, Ronden Nu!\",\"StrijkenBeidenBoorden\":\"Klaarmaken om te strijken.. strijken nu\"},\"translations\":{\"BakboortBest\":\"BB Best\",\"HalenBeideBoorden\":\"Halen\",\"LightPaddle\":\"Light paddle\",\"LightPaddleBedankt\":\"Light paddle bedankt\",\"PeddelendStrijkenBB\":\"Slippend strijken BB\",\"PeddelendStrijkenSB\":\"Slippend strijken SB\",\"RiemenHoogBB\":\"Overhellen waterzijde (SB)\",\"RiemenHoogSB\":\"Overhellen waterzijde (BB)\",\"RondmakenBB\":\"Ronden BB\",\"RondmakenSB\":\"Ronden SB\",\"StrijkenBB\":\"BB\",\"StrijkenBeidenBoorden\":\"Strijken\",\"StrijkenSB\":\"SB\",\"StuurboordBest\":\"SB Sterk\",\"UitbrengenBB\":\"BB\",\"UitbrengenSB\":\"SB\",\"VastroeienBB\":\"BB\",\"VastroeienBeideBoorden\":\"Vastroeien\",\"VastroeienSB\":\"SB\",\"VastroeienSterk\":\"Houden!\"}}"
	},
]

const sharedSettingLangKey= "custom"
var languageKeys=[]
var urlKeys=[]
var flags=[]
var languageLongItems=[]
var baseConfigs=[]

func _init():
	for setting in initalSettings:
		languageKeys.append(setting["key"])
		urlKeys.append(setting["urlKey"])
		flags.append(setting["flag"])
		languageLongItems.append(setting["displayName"])
		baseConfigs.append(setting["baseConfig"])
	# custom will be added to the end of the array's when shared settings is loaded
	
