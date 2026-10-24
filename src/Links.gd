extends RichTextLabel

# open the clicked link (project page or social media icon)

func _ready():
	connect("meta_clicked",self,"_on_meta_clicked")

func _on_meta_clicked(meta):
	Utilities.openLink(meta)
