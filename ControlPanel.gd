extends Control

export (NodePath) var player_path
var SettingSlider = preload("res://SettingSlider.tscn")
var player = null
# wheel_base 40
# angular_easing 0.15
# angular_step 0.01


var car_settings = [ 'max_speed',
		 'max_turn', 'lowTurnSpeed'
		]

var ranges = {'max_speed': [10, 150, 10],
			'max_turn': [0.1, 2, 0.01],
			'lowTurnSpeed': [1, 50, 1]
			}
			
func _ready():
	if player_path:
		player = get_node(player_path)
		for setting in car_settings:
			var ss = SettingSlider.instance()
			ss.name = setting
			$Panel/VBoxContainer.add_child(ss)
			ss.get_node("Slider").min_value = ranges[setting][0]
			ss.get_node("Slider").max_value = ranges[setting][1]
			ss.get_node("Slider").step = ranges[setting][2]
			ss.get_node("Slider").value = player.get(setting)
			ss.get_node("Label").text = setting
			ss.get_node("Value").text = str(player.get(setting))	
			ss.get_node("Slider").connect("value_changed", self, "_on_Value_changed", [ss])
			
func _on_Value_changed(value, node):
	player.set(node.name, value)
	node.get_node("Value").text = str(value)

func _input(event):
	
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F1:
			visible = !visible

func _process(delta):
	if player:
#		var value=player.velocity.length()
		var value=$"../../Boat".calcSpeed()
		$Panel/VBoxContainer/Speedometer/Speed.text = "%4.3f" % value
		var turnValue=$"../../Boat".angular_velocity
		$Panel/VBoxContainer/turnMeter/value.text = "%4.3f" % turnValue
		
