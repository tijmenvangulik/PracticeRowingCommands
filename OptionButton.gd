extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var languageItems=["Nederlands viking","Nederlands","English"]
var languageKeys=["nl_NL","nl","en"]
# Called when the node enters the scene tree for the first time.
func _ready():
	var i=0;
	for item in languageItems:		
		add_item(item,i)
		i=i+1
	
	connect("item_selected",self,"selected")
	
	pass # Replace with function body.

func selected(itemIndex : int):
	
	if itemIndex>=0:
		var langKey=languageKeys[itemIndex]
		TranslationServer.set_locale(langKey)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
