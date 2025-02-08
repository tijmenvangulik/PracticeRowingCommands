extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func loadLanguages():
	var list=$ScrollContainer/Panel/ItemList
	var i=0;
	for item in Constants.languageLongItems:
		var flagName=Constants.flags[i]
		var texture=load("res://assets/flags/"+flagName+".svg")
		list.add_item(item,texture)
		#list.set_item_metadata(1,)
		i=i+1
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	loadLanguages()
	get_close_button().hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func showDialog():
	var list=$ScrollContainer/Panel/ItemList
	var itemIndex=$"%OptionLanguage".selected;
	list.select(itemIndex)
	show_modal(true)
	$ScrollContainer/Panel/ItemList.grab_focus()
	
func _on_StartIntro_pressed():
	hide()
	$"%RightTopButtons".visible=true
	$"%ButtonsContainer".visible=true

	$"%IntroDialog".start()


func _on_ItemList_item_selected(index):
	$"%OptionLanguage".selected(index)
