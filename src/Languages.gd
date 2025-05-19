extends Node

#const languageItems=["NL Viking","EN Viking","Nederlands","English","English 2"]
const sharedSettingLangKey= "custom"
var languageKeys=["nl_NL","en_BW","nl","en","en_US","nl_AW"]
var urlKeys=["nl_viking","en_viking","nl","en","en2","nl_hemus"]
var flags=["nl_viking","gb_viking","nl","gb","gb","nl_hemus"]
var languageLongItems=["Nederlands / Viking","English / Viking (dutch commands)","Nederlands / Generiek","English / Generic 1","English / Generic 2","Nederlands / Hemus"]

const english2Config="{\"tooltips\":{},\"language\":\"en\",\"translations\":{\"BakboortBest\":\"Strong port\",\"HaalBB\":\"1 Stroke port\",\"HaalSB\":\"1 Stroke starboard\",\"HalenBB\":\"Stroke port\",\"HalenSB\":\"Stroke starboard\",\"IntrekkenBB\":\"Pull in port\",\"IntrekkenSB\":\"Pull in starboard\",\"PeddelendStrijkenBB\":\"Along side back down port\",\"PeddelendStrijkenSB\":\"Along side back down starbard\",\"RiemenHoogBB\":\"Oars hight port\",\"RiemenHoogSB\":\"Oars hight starboard\",\"RondmakenBB\":\"Spin turn port\",\"RondmakenSB\":\"Spin turn starboard\",\"SlippenBB\":\"Blades along port\",\"SlippenSB\":\"Blades along starboard\",\"StrijkBB\":\"1 Back down port\",\"StrijkSB\":\"1 Back down starboard\",\"StrijkenBB\":\"Back down port\",\"StrijkenSB\":\"Back down starboard\",\"StuurboordBest\":\"Strong starboard\",\"UitbrengenBB\":\"Out oars port\",\"UitbrengenSB\":\"Out oars starboard\",\"UitzettenBB\":\"Push away port\",\"UitzettenSB\":\"Push away starboard\",\"VastroeienBB\":\"Hold port\",\"VastroeienSB\":\"Hold starboard\"}}"
var baseConfigs=["","","","",english2Config,""]

