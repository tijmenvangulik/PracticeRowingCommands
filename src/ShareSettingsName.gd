extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var nameControl :TextEdit
var previewTextControl :Label
var colorPicker : ColorPickerButton

func _ready():
	nameControl= $GridContainer/Name
	previewTextControl = $GridContainer/Panel/PreviewText
	colorPicker=$GridContainer/Panel2/ColorPickerButton
	if GameState.mobileMode:
		margin_left-=150
		margin_right+=100
		margin_bottom+=50

# Called when the node enters the scene tree for the first time.
func start():
	setBladeColor(GameState.sharedSettingsBladeColor)
	colorPicker.color=GameState.sharedSettingsBladeColor
	setPreviewText()
	show_modal(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ShareSettings_pressed():
	hide()
	var shortSettings=$GridContainer/Panel4/ShortSharedSettings.pressed
	$"%ShareSettingsDialog".start(nameControl.text,shortSettings)


func _on_Cancel_pressed():
	hide()
	
func setBladeColor(color):
	
	GameState.sharedSettingsBladeColor=color
	var preview=$GridContainer/Panel/CustomBladePreview
	var flag=Utilities.languageToFlag(TranslationServer.get_locale())	
	preview.texture=Utilities.getColoredBlade(color,flag)

func _on_ColorPickerButton_color_changed(color):
	setBladeColor(color)
	

func setPreviewText():

	if nameControl.text=="":
		previewTextControl.text=tr("SharedSettings")
	else:
		previewTextControl.text=nameControl.text
	
func _on_Name_text_changed():
	setPreviewText()
