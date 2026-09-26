extends Node2D

@export var count = 3
@export var sprite_scale = 0.25

var evil_textures = [
	preload("res://evil/green.svg"),
	preload("res://evil/horns.svg"),
	preload("res://evil/red_nose.svg"),
	preload("res://evil/shadow.svg"),
]

func _ready():
	var viewport_size = get_viewport_rect().size
	var margin = 32.0
	for i in range(count):
		var sprite = Sprite2D.new()
		sprite.texture = evil_textures[randi() % evil_textures.size()]
		sprite.scale = Vector2(sprite_scale, sprite_scale)
		sprite.position = Vector2(
			randf_range(margin, viewport_size.x - margin),
			randf_range(margin, viewport_size.y - margin)
		)
		add_child(sprite)
