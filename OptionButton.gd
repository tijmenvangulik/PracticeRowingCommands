extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var languageItems=["Nederlands viking","Nederlands","English"]
var languageKeys=["nl_NL","nl","en"]
var isViking=true
# Called when the node enters the scene tree for the first time.
func _ready():
	var i=0;
	for item in languageItems:		
		add_item(item,i)
		i=i+1
	
	connect("item_selected",self,"selected")
	setDynamicTexts()
	
func setDynamicTexts():
	var textBB="UitzettenBB"
	var textSB="UitzettenSB"
	if isViking:
		 textBB="PeddelendStrijkenBB"
		 textSB="PeddelendStrijkenSB"
	
	$"../ButtonsContainer/GridContainer/PeddelendStrijkenSB".text=tr(textSB)
	$"../ButtonsContainer/GridContainer/PeddelendStrijkenBB".text=tr(textBB)
	
func selected(itemIndex : int):
	
	if itemIndex>=0:
		var langKey=languageKeys[itemIndex]
		isViking= langKey=="nl_NL"
		TranslationServer.set_locale(langKey)
		setDynamicTexts()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
