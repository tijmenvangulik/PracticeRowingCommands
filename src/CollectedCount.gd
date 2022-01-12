extends HBoxContainer

class_name CollectedCounter

func setCount(value,maxValue):
	$"CountValue".text=String(value)+" / "+String(maxValue)

func updateTime(timeStr):
	$"ElapsedTime".text=timeStr
	
func setHighScore(timeStr):
	var text= tr("BestHighscore") % timeStr
	$"HighScore".text=text
