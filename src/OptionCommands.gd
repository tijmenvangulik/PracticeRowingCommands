extends OptionButton

var commandTitles= ["HalenBeideBoorden",
  "LaatLopen","Bedankt","HalenSB","StrijkenSB",
  "VastroeienSB","StrijkenBeidenBoorden","VastroeienBeideBoorden",
  "HalenBB","StrijkenBB","VastroeienBB",
  "PeddelendStrijkenBB","PeddelendStrijkenSB",
  "RondmakenBB","RondmakenSB"]

const USE_BUTTONS=999

var _enabledCommands = [];
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
	GameEvents.connect("customCommandTextChanged",self,"_on_EditCommandText_customCommandTextChanged")
	GameEvents.connect("commandsChangedSignal",self,"_commandsChangedSignal")
	GameEvents.connect("introSignal",self,"_introSignal")
	var styleDropDown= preload("res://MainDropDown.tres")
	get_popup().add_stylebox_override("panel",styleDropDown)
	GameEvents.register_tooltip(self,"OptionCommandsTooltip")
	GameEvents.connect("languageChangedSignal",self,"_languageChangedSignal")
	
func _introSignal(isVisible : bool):
	visible=!isVisible
	if !isVisible:
		grab_focus()

func fillDropDown(enabledCommands : Array):
	_enabledCommands=enabledCommands
	clear()
	add_item("UseButtons",USE_BUTTONS)
	var i=0;
	for commandName in Constants.commandNames:
		if (len(enabledCommands)==0 || enabledCommands.find(i,0)>=0 ) && Utilities.commandIsUsed(commandName):
			var caption=tr(commandName)
			var altCaption=Utilities.getCommandTranslation(i)
			if altCaption!="":
				caption=altCaption;
			add_item(caption,i)
		i=i+1
	GameEvents.showButtons(true)


func selected(itemIndex : int):
	var value=get_selected_id()
	
	var useButtons=value==USE_BUTTONS ;
	GameEvents.showButtons(useButtons)
	
	if !useButtons:
		GameEvents.doCommand(value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EditCommandText_customCommandTextChanged(command, commandName, value):
	set_item_text(command+1,value)
	
func _commandsChangedSignal(showOnlyButonsArray : Array):
	fillDropDown(showOnlyButonsArray)

func _languageChangedSignal():
	# should do here something to make the keys work again
	fillDropDown(_enabledCommands)
