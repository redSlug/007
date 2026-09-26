extends CanvasLayer

func _ready():
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var win_text = $WinText
	win_text.reparent(center)
