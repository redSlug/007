extends Node2D

@export var radius = 20.0
@export var color = Color.CORNFLOWER_BLUE

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
