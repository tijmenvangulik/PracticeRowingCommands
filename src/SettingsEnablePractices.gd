extends Tabs

class_name EnablePracticesTab

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func addCheckbox(text : String,startItem : int):
	var isVisible=Practices.practiceIsEnabled(startItem)
	var isEnabled=Practices.practiceIsLanguageEnabled(startItem)
	
	var container=$GridContainer
	var new_checkBox = CheckBox.new()
	new_checkBox.text=text
	new_checkBox.pressed=isVisible
	new_checkBox.add_font_override("font",load("res://Font.tres"))
	new_checkBox.margin_top=8
	new_checkBox.name=str(startItem)
	new_checkBox.disabled=!isEnabled
	container.add_child(new_checkBox)
	return new_checkBox

func loadPractices():
	var children = $GridContainer.get_children()
	for child in children:
		child.free()
	for practice in Practices.practices:
		if practice!= Constants.StartItem.StartTour && practice!= Constants.StartItem.StarGame:
			addCheckbox(Practices.getPracticeName(practice),practice)

func init():
	loadPractices()

func savePractices():
	var disabledPractices=[]
	for i in $GridContainer.get_child_count():
		var checkItem=$GridContainer.get_child(i)
		if !checkItem.pressed:
			var startItem=int( checkItem.name)
			disabledPractices.append(startItem)
	
	if disabledPractices!=Settings.disabledPractices:
		Settings.disabledPractices=disabledPractices
		GameEvents.practicesChanged()
		GameEvents.settingsChanged()
		
#func setPracticesCheckboxes():
#	pass
		
func _on_SettingsDialog_visibility_changed():
	if !$"../..".visible:
		savePractices()
	else:
		loadPractices()
