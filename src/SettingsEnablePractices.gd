extends Tabs

class_name EnablePracticesTab

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var grid : GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	grid=$ScrollContainer/GridContainer

func addLabel(container,text,color):
	var new_label = Label.new()
	new_label.text=text
	if color!="":
		new_label.add_color_override("font_color",color)
	new_label.add_font_override("font",load("res://Font.tres"))
	container.add_child(new_label)
	return new_label


func addCheckbox(startItem : int):
	var isVisible=Practices.practiceIsEnabled(startItem)
	
	var container=grid
	var new_checkBox = CheckBox.new()
	new_checkBox.pressed=isVisible
	new_checkBox.add_font_override("font",load("res://Font.tres"))
	new_checkBox.margin_top=8
	new_checkBox.name=str(startItem)
	new_checkBox.disabled=Settings.disabledPracticesUseDefault
	container.add_child(new_checkBox)
	return new_checkBox

func addButton(container,text,startItem : int):
	var button = preload("res://PracticeEditTextButton.tscn").instance()
	container.add_child(button)
	button.visible=true;
	button.init(text,startItem,$"%ModifyPracticeDialog")
	
func loadPractices():
	$UseDefaultPractices.pressed=Settings.disabledPracticesUseDefault
	var children = grid.get_children()
	for child in children:
		child.free()
	var headerColor="9ca5b5"
	addLabel(grid,tr("Practice"),headerColor)
	addLabel(grid,tr("Visible"),headerColor)
	addLabel(grid,tr("Text"),headerColor)
	#addLabel(grid,practiceText)
	for practice in Practices.practices:
		if practice!= Constants.StartItem.StartTour && practice!= Constants.StartItem.StarGame:
			var practiceText=Practices.getPracticeName(practice)
			addLabel(grid,practiceText,"")
			addCheckbox(practice)
			addButton(grid,practiceText,practice)

func init():
	loadPractices()

func savePractices():
	
	var disabledPractices=[]
	if !Settings.disabledPracticesUseDefault:
		for i in grid.get_child_count():
			#for the second column
			if i>=grid.columns &&  i % grid.columns ==1:
				var checkItem=grid.get_child(i)
				if !checkItem.pressed:
					var startItem=int( checkItem.name)
					disabledPractices.append(startItem)
					
	var practiceTranslations=[]
	for i in grid.get_child_count():
		#for the 3de column
		if i>=grid.columns && i % grid.columns == 2:
			var buttonTextItem=grid.get_child(i)
			practiceTranslations=Practices.calcSetPracticeTranslation(practiceTranslations, buttonTextItem.startPos,buttonTextItem.modifiedTitle)

		
	if disabledPractices!=Settings.disabledPractices || practiceTranslations!=Settings.practiceTranslations:
		Settings.disabledPractices=disabledPractices
		Settings.practiceTranslations=practiceTranslations;
		GameEvents.practicesChanged()
		GameEvents.settingsChanged()
		

func _on_UseDefaultPractices_toggled(button_pressed):
	pass


func _on_UseDefaultPractices_pressed():
	Settings.disabledPracticesUseDefault=$UseDefaultPractices.pressed
	if Settings.disabledPracticesUseDefault:
		Settings.disabledPractices=[]
	else:
		Settings.disabledPractices=Practices.languageDisabledPractices
	GameEvents.practicesChanged()
	GameEvents.settingsChanged()
	loadPractices()
