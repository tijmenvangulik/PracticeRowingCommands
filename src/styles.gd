extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var styleButtonDarkGray = preload("res://StyleButtonDarkGray.tres") as StyleBoxFlat
var styleButtonSB=preload("res://StyleButtonSB.tres") as StyleBoxFlat
var styleButtonBB=preload("res://StyleButtonBB.tres") as StyleBoxFlat
var styleButtonGray=preload("res://StyleButtonGray.tres") as StyleBoxFlat

var amount=0.2

var styleButtonDarkGrayHighContrast = newDarkenStyle(styleButtonDarkGray,amount)
var styleButtonSBHighContrast = newDarkenStyle(styleButtonSB,amount)
var styleButtonBBHighContrast = newDarkenStyle(styleButtonBB,amount)
var styleButtonGrayHighContrast = newDarkenStyle(styleButtonGray,amount)


var styleButtonDarkGrayFocus = preload("res://StyleButtonDarkGrayFocus.tres") as StyleBoxFlat
var styleButtonSBFocus=preload("res://StyleButtonSBFocus.tres") as StyleBoxFlat
var styleButtonBBFocus=preload("res://StyleButtonBBFocus.tres") as StyleBoxFlat
var styleButtonGrayFocus=preload("res://StyleButtonGrayFocus.tres") as StyleBoxFlat

var amountFocus=0.5;
var styleButtonDarkGrayFocusHighContrast = newDarkenStyle(styleButtonDarkGrayFocus,amountFocus)
var styleButtonSBFocusHighContrast = newDarkenStyle(styleButtonSBFocus,amountFocus)
var styleButtonBBFocusHighContrast = newDarkenStyle(styleButtonBBFocus,amountFocus)
var styleButtonGrayFocusHighContrast = newDarkenStyle(styleButtonGrayFocus,amountFocus)

var styleButtonDarkGrayPressed = preload("res://StyleButtonDarkGrayPressed.tres") as StyleBoxFlat
var styleButtonSBPressed=preload("res://StyleButtonSBPressed.tres") as StyleBoxFlat
var styleButtonBBPressed=preload("res://StyleButtonBBPressed.tres") as StyleBoxFlat
var styleButtonGrayPressed=preload("res://StyleButtonGrayPressed.tres") as StyleBoxFlat

var amountPressed=0.5

var styleButtonDarkGrayPressedHighContrast = newDarkenStyle(styleButtonDarkGrayPressed,amountPressed)
var styleButtonSBPressedHighContrast = newDarkenStyle(styleButtonSBPressed,amountPressed)
var styleButtonBBPressedHighContrast = newDarkenStyle(styleButtonBBPressed,amountPressed)
var styleButtonGrayPressedHighContrast = newDarkenStyle(styleButtonGrayPressed,amountPressed)


var styleButtonDarkGrayHover = preload("res://StyleButtonDarkGrayHover.tres") as StyleBoxFlat
var styleButtonSBHover=preload("res://StyleButtonSBHover.tres") as StyleBoxFlat
var styleButtonBBHover=preload("res://StyleButtonBBHover.tres") as StyleBoxFlat
var styleButtonGrayHover=preload("res://StyleButtonGrayHover.tres") as StyleBoxFlat

var amountHover=0.5

var styleButtonDarkGrayHoverHighContrast = newDarkenStyle(styleButtonDarkGrayHover,amountHover)
var styleButtonSBHoverHighContrast = newDarkenStyle(styleButtonSBHover,amountHover)
var styleButtonBBHoverHighContrast = newDarkenStyle(styleButtonBBHover,amountHover)
var styleButtonGrayHoverHighContrast = newDarkenStyle(styleButtonGrayHover,amountHover)

var styleDisabled= preload("res://ButtonDisabled.tres")

# ----------- main drop down

var styleMainDropDown = preload("res://MainDropDown.tres") as StyleBoxFlat
var styleMainDropDownHover=preload("res://MainDropDownHover.tres") as StyleBoxFlat
var styleMainDropDownFocus=preload("res://MainDropFocus.tres") as StyleBoxFlat

var styleMainDropDownHighContrast = newDarkenStyle(styleMainDropDown,amount)
var styleMainDropDownHoverHighContrast = newDarkenStyle(styleMainDropDownHover,amount)
var styleMainDropDownFocusHighContrast = newDarkenStyle(styleMainDropDownFocus,amount)

# --- start button

var styleStartButton = preload("res://StyleStartButton.tres") as StyleBoxFlat
var styleStartButtonHover=preload("res://StyleStartButtonHover.tres") as StyleBoxFlat
var styleStartButtonFocus=preload("res://StyleStartButtonFocus.tres") as StyleBoxFlat

var styleStartButtonHighContrast = newDarkenStyle(styleStartButton,amount)
var styleStartButtonHoverHighContrast = newDarkenStyle(styleStartButtonHover,amount)
var styleStartButtonFocusHighContrast = newDarkenStyle(styleStartButtonFocus,amount)

func newDarkenStyle(style : StyleBoxFlat,amount)-> StyleBoxFlat:
	style=style.duplicate(true)
	
	style.bg_color.a=1
	style.bg_color=style.bg_color.darkened(amount)
	return style
	
func setButtonStyle(styleNr, button):
	var style : StyleBoxFlat=null

	if Settings.highContrast:
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = Styles.styleButtonDarkGrayHighContrast
			Constants.CommandStyle.StyleButtonSB:
				style = Styles.styleButtonSBHighContrast
			Constants.CommandStyle.StyleButtonBB:
				style = Styles.styleButtonBBHighContrast
			Constants.CommandStyle.StyleButtonGray:
				style= Styles.styleButtonGrayHighContrast
	else:
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = Styles.styleButtonDarkGray
			Constants.CommandStyle.StyleButtonSB:
				style = Styles.styleButtonSB
			Constants.CommandStyle.StyleButtonBB:
				style = Styles.styleButtonBB
			Constants.CommandStyle.StyleButtonGray:
				style= Styles.styleButtonGray
	button.add_stylebox_override("normal",style)
	
	
	if Settings.highContrast:
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = Styles.styleButtonDarkGrayFocusHighContrast
			Constants.CommandStyle.StyleButtonSB:
				style = Styles.styleButtonSBFocusHighContrast
			Constants.CommandStyle.StyleButtonBB:
				style = Styles.styleButtonBBFocusHighContrast
			Constants.CommandStyle.StyleButtonGray:
				style= Styles.styleButtonGrayFocusHighContrast
	else:
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = Styles.styleButtonDarkGrayFocus
			Constants.CommandStyle.StyleButtonSB:
				style = Styles.styleButtonSBFocus
			Constants.CommandStyle.StyleButtonBB:
				style = Styles.styleButtonBBFocus
			Constants.CommandStyle.StyleButtonGray:
				style= Styles.styleButtonGrayFocus
				
	button.add_stylebox_override("focus",style)
	
	if Settings.highContrast:
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = Styles.styleButtonDarkGrayPressedHighContrast
			Constants.CommandStyle.StyleButtonSB:
				style = Styles.styleButtonSBPressedHighContrast
			Constants.CommandStyle.StyleButtonBB:
				style = Styles.styleButtonBBPressedHighContrast
			Constants.CommandStyle.StyleButtonGray:
				style= Styles.styleButtonGrayPressedHighContrast
	else:
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = Styles.styleButtonDarkGrayPressed
			Constants.CommandStyle.StyleButtonSB:
				style = Styles.styleButtonSBPressed
			Constants.CommandStyle.StyleButtonBB:
				style = Styles.styleButtonBBPressed
			Constants.CommandStyle.StyleButtonGray:
				style= Styles.styleButtonGrayPressed
	button.add_stylebox_override("pressed",style)
	
	if Settings.highContrast:
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = Styles.styleButtonDarkGrayHoverHighContrast
			Constants.CommandStyle.StyleButtonSB:
				style = Styles.styleButtonSBHoverHighContrast
			Constants.CommandStyle.StyleButtonBB:
				style = Styles.styleButtonBBHoverHighContrast
			Constants.CommandStyle.StyleButtonGray:
				style= Styles.styleButtonGrayHoverHighContrast
	
	else:
		match styleNr:
			Constants.CommandStyle.StyleButtonDarkGray:
				style = Styles.styleButtonDarkGrayHover
			Constants.CommandStyle.StyleButtonSB:
				style = Styles.styleButtonSBHover
			Constants.CommandStyle.StyleButtonBB:
				style = Styles.styleButtonBBHover
			Constants.CommandStyle.StyleButtonGray:
				style= Styles.styleButtonGrayHover
	
	button.add_stylebox_override("hover",style)
	
	button.add_stylebox_override("disabled",styleDisabled)
	
	if Settings.highContrast:
		button.add_color_override("font_color_hover",Color(1,1,1))
		button.add_color_override("font_color_focus",Color(1,1,1))
	else:
		button.remove_color_override("font_color_hover")
		button.remove_color_override("font_color_focus")
		
		
func SetMainDropDownStyle(button):
	if Settings.highContrast:
		button.add_stylebox_override("normal",Styles.styleMainDropDownHighContrast)
		button.add_stylebox_override("hover",Styles.styleMainDropDownHoverHighContrast)
		button.add_stylebox_override("focus",Styles.styleMainDropDownFocusHighContrast)
		button.add_stylebox_override("pressed",Styles.styleMainDropDownFocusHighContrast)
	else:
		button.add_stylebox_override("normal",Styles.styleMainDropDown)
		button.add_stylebox_override("hover",Styles.styleMainDropDownHover)
		button.add_stylebox_override("focus",Styles.styleMainDropDownFocus)
		button.add_stylebox_override("pressed",Styles.styleMainDropDownFocus)

func SetStartButtonStyle(button):
	if Settings.highContrast:
		button.add_stylebox_override("normal",Styles.styleStartButtonHighContrast)
		button.add_stylebox_override("hover",Styles.styleStartButtonHoverHighContrast)
		button.add_stylebox_override("focus",Styles.styleStartButtonFocusHighContrast)
		button.add_stylebox_override("pressed",Styles.styleStartButtonFocusHighContrast)
	else:
		button.add_stylebox_override("normal",Styles.styleStartButton)
		button.add_stylebox_override("hover",Styles.styleStartButtonHover)
		button.add_stylebox_override("focus",Styles.styleStartButtonFocus)
		button.add_stylebox_override("pressed",Styles.styleStartButtonFocus)

func setFontColorOverride(label):
	if Settings.highContrast:
		label.add_color_override("font_color",Color("#121317"))
	else:
		label.remove_color_override("font_color")
