extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var commandTitles= ["HalenBeideBoorden",
  "LaatLopen","Bedankt","HalenSB","StrijkenSB",
  "VastroeienSB","StrijkenBeidenBoorden","VastroeienBeideBoorden",
  "HalenBB","StrijkenBB","VastroeienBB",
  "PeddelendStrijkenBB","PeddelendStrijkenSB",
  "RondmakenBB","RondmakenSB"]
const USE_BUTTONS=999

#func _gui_input(ev):
#	var popup=get_popup();
#	if has_focus() && popup!=null && !popup.visible && ev is InputEventKey and ev.scancode != KEY_ENTER and not ev.echo:
#		popup.visible=true
		
		#var oldCode=ev.scancode
		#ev.scancode=KEY_ENTER
		#emit_signal("gui_input",ev)
		#ev.scancode=KEY_ENTER
		#emit_signal("gui_input",ev)
		
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	fillDropDown([])
	connect("item_selected",self,"selected")

func fillDropDown(enabledCommands : Array):
	clear()
	add_item(tr("UseButtons"),USE_BUTTONS)
	var boat=$"../../Boat"
	var i=0;
	var buttonContainter=$"../ButtonsContainer";
	for commandName in boat.commandNames:
		if (len(enabledCommands)==0 || enabledCommands.find(i,0)>=0 ) && buttonContainter.commandIsUsed(commandName):
			add_item(commandName,i)
		i=i+1

func selected(itemIndex : int):
	var value=get_selected_id()
	
	var buttons=$"../ButtonsContainer"
	var useButtons=value==USE_BUTTONS ;
	buttons.visible= useButtons
	var boat=$"../../Boat"
	
	if !useButtons:
		boat.doCommand(value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EditCommandText_customCommandTextChanged(command, commandName, value):
	set_item_text(command+1,value)
