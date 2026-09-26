extends Area2D

var exploding = false

func _ready():
	add_to_group("evil")

func player_overlapping() -> bool:
	if exploding:
		return false
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false

func explode():
	if exploding:
		return
	exploding = true
	monitoring = false
	var sprite = $Sprite2D
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", sprite.scale * 2.5, 0.2)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(queue_free)
