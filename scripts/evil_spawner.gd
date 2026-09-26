extends Node2D

const EvilCharacterScript = preload("res://scripts/evil_character.gd")

@export var count = 3
@export var sprite_scale = 0.25
@export var min_distance = 60.0
@onready var end_screen = get_node("../EndScreen")

var evil_variants = [
	{"texture": preload("res://evil/green.svg"), "sound": preload("res://sfx/green.wav")},
	{"texture": preload("res://evil/horns.svg"), "sound": preload("res://sfx/horns.wav")},
	{"texture": preload("res://evil/red_nose.svg"), "sound": preload("res://sfx/red_nose.wav")},
	{"texture": preload("res://evil/shadow.svg"), "sound": preload("res://sfx/shadow.wav")},
]

func _process(_delta):
	_detect_end()

func _detect_end():
	if get_child_count() == 0:
		end_screen.visible = true

func _ready():
	var viewport_size = get_viewport_rect().size
	var margin = 32.0
	var placed_positions = []
	for i in range(count):
		var pos = _find_spawn_position(viewport_size, margin, placed_positions)
		placed_positions.append(pos)
		var evil = _create_evil_character()
		evil.position = pos
		add_child(evil)

func _find_spawn_position(viewport_size: Vector2, margin: float, placed_positions: Array) -> Vector2:
	var pos = Vector2.ZERO
	var attempts = 0
	while attempts < 100:
		pos = Vector2(
			randf_range(margin, viewport_size.x - margin),
			randf_range(margin, viewport_size.y - margin)
		)
		var far_enough = true
		for other in placed_positions:
			if pos.distance_to(other) < min_distance:
				far_enough = false
				break
		if far_enough:
			return pos
		attempts += 1
	return pos

func _create_evil_character() -> Area2D:
	var variant = evil_variants[randi() % evil_variants.size()]
	var texture = variant["texture"]

	var area = Area2D.new()
	area.set_script(EvilCharacterScript)
	area.explosion_sound = variant["sound"]

	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	sprite.texture = texture
	sprite.scale = Vector2(sprite_scale, sprite_scale)
	area.add_child(sprite)

	var collision_shape = CollisionShape2D.new()
	collision_shape.name = "CollisionShape2D"
	var circle = CircleShape2D.new()
	circle.radius = texture.get_width() * sprite_scale / 2.0
	collision_shape.shape = circle
	area.add_child(collision_shape)
	
	return area
