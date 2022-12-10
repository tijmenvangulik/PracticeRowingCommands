extends MarginContainer

onready var anim = $AnimationPlayer
onready var label = $M2/H1/CenterLabel/Label
var showing = false


var placement_offset :=Vector2(0.0,0.0)
var placement:=Vector2(0,0)
var showAbove = true

func _ready():
	#ui_signals is an autoloaded signal repository.
	GameEvents.connect("toggle_tooltip",self,"_on_toggle_tooltip")
	showing=false
	anim.seek(0)
	
func _process(delta):
	if showing:
		visible=true
		if showAbove:
			placement_offset.y = -self.rect_size.y
		else :
			placement_offset.y = 30
		self.set_global_position(placement + placement_offset)
		self.set_size(Vector2(10.0,10.0))
	
func _on_toggle_tooltip(do_show,node, tooltip_text):
	self.set_size(Vector2(10.0,10.0))
	placement = node.rect_global_position
	
	var half_height= get_viewport_rect().size.y*.5	
	if placement.y < half_height:
		showAbove=false
	else: 
		showAbove=true
		
	var half_width = get_viewport_rect().size.x*.5	
	if placement.x < half_width:
		placement_offset.x =0
	else:
		placement_offset.x = -self.rect_size.x + node.rect_size.x
	if do_show:
		if not showing:
			var text=""
			if typeof(tooltip_text) == TYPE_STRING:
				text = tooltip_text
			elif typeof(tooltip_text) == TYPE_OBJECT && tooltip_text.has_method("get_tooltip_text") :
				 text= tooltip_text.get_tooltip_text(node)
			if text!=null && text!="":
				label.text=text
				anim.play("ShowTooltip")
			else:
				do_show=false
			
	else:
		if showing:
			anim.play_backwards("ShowTooltip")	
	showing = do_show

