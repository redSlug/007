extends Area2D

const ExplosionSound = preload("res://sfx/explosion.wav")

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
	_play_explosion_sound()
	var sprite = $Sprite2D
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", sprite.scale * 2.5, 0.2)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(queue_free)

func _play_explosion_sound():
	var player = AudioStreamPlayer.new()
	player.stream = ExplosionSound
	get_tree().current_scene.add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
