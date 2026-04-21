extends HBoxContainer

class_name CollectedCounter

func _ready():
	GameEvents.connect("highContrastChangedSignal",self,"_highContrastChangedSignal")
	if GameState.mobileMode:
		$CenterContainer/Sprite.offset.y+=14
func setCount(value,maxValue):
	$"CountValue".text=String(value)+" / "+String(maxValue)

func updateTime(timeStr):
	$"ElapsedTime".text=timeStr
	
func setHighScore(timeStr):
	var text= tr("BestHighscore") % timeStr
	$"HighScore".text=text

func _highContrastChangedSignal(highContrast):
	
	Styles.setFontColorOverride($CountValue)
	Styles.setFontColorOverride($ElapsedTime)
	Styles.setFontColorOverride($HighScore)
