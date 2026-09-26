extends CanvasLayer

@onready var win_text: Label = $WinText

func _ready():
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	win_text.reparent(center)

func show_message(text: String):
	win_text.text = text
	show()

func hide_message():
	hide()
