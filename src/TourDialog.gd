extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tourStep=1
var tourTexts= ["OptionLanguageTooltip","OptionStartTooltip","ShowHideTootipsTooltip","SettingsButtonTooltip","ForwardsBackwardsTooltip","CommandsTourText"]
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("startTour",self,"_on_startTour")
	GameEvents.connect("languageChangedSignal",self,"_on_languageChanged")
	
	get_close_button().hide()

func _on_startTour():
	tourStep=1
	ShowStep()
	visible=true

func _on_languageChanged():
	if visible:
		ShowStep()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TourStop_pressed():
	stopTour()


func _on_TourNext_pressed():
	tourStep=tourStep+1
	ShowStep()

func stopTour():
	visible=false
	
func ShowStep():
	$"PointToLanguage".visible=tourStep==1
	$"PointToStart".visible=tourStep==2
	$"PointToHelp".visible=tourStep==3
	$"PointToOptions".visible=tourStep==4
	$"PointToBackwards".visible=tourStep==5
	$"PointToCommands".visible=tourStep==6
	if tourStep<=tourTexts.size():
		$"TourText".set_bbcode(Utilities.replaceCommandsInText( tr(tourTexts[tourStep-1]),true))
	else:
		stopTour()
	$HSplitContainer/TourNext.visible=tourStep<tourTexts.size()

