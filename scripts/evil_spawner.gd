extends Node2D

const EvilCharacterScript = preload("res://scripts/evil_character.gd")

@export var count = 3
@export var sprite_scale = 0.25
@export var min_distance = 60.0
@export var max_level = 3
@export var level_complete_pause = 2.0
@export var level_time_limit = 5.0
@onready var end_screen = get_node("../EndScreen")
@onready var timer_label = get_node("../HUD/TimerLabel")

var evil_variants = [
	{"texture": preload("res://evil/green.svg"), "sound": preload("res://sfx/green.wav")},
	{"texture": preload("res://evil/horns.svg"), "sound": preload("res://sfx/horns.wav")},
	{"texture": preload("res://evil/red_nose.svg"), "sound": preload("res://sfx/red_nose.wav")},
	{"texture": preload("res://evil/shadow.svg"), "sound": preload("res://sfx/shadow.wav")},
]

var current_level = 1
var level_transitioning = false
var game_over = false
var time_remaining = 0.0

func _process(delta):
	if game_over or level_transitioning:
		return

	time_remaining -= delta
	timer_label.text = "Time: %d" % maxi(ceili(time_remaining), 0)
	if time_remaining <= 0:
		_on_time_up()
		return

	_detect_end()

func _detect_end():
	if get_child_count() == 0:
		_on_level_cleared()

func _on_level_cleared():
	level_transitioning = true
	if current_level >= max_level:
		end_screen.show_message("You Won!")
	else:
		end_screen.show_message("Level %d complete!" % current_level)
		await get_tree().create_timer(level_complete_pause).timeout
		end_screen.hide_message()
		current_level += 1
		level_transitioning = false
		_spawn_level()

func _on_time_up():
	game_over = true
	for evil in get_children():
		evil.queue_free()
	end_screen.show_message("Time out - Game Over")

func _ready():
	_spawn_level()

func _spawn_level():
	time_remaining = level_time_limit

	var level_count = count
	for i in range(current_level - 1):
		level_count *= 2

	var viewport_size = get_viewport_rect().size
	var margin = 32.0
	var placed_positions = []
	for i in range(level_count):
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
