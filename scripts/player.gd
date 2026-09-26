extends CharacterBody2D

@export var speed = 400

func _ready():
	add_to_group("player")
	RCadeInput.enable_classic_controls()
	
	# uncomment this and add the dependency
	# to your manifest to enable spinners:
	#
	# RCadeInput.enable_spinners()
	
func get_input():
	var input_direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	velocity = input_direction * speed

func _physics_process(delta):
	$Icon.modulate = Color.RED if Input.is_action_pressed("one_player") else Color.WHITE
	if Input.is_action_just_pressed("p1_a"):
		rotate(PI / 4.0)
	if Input.is_action_just_pressed("p1_a") or Input.is_action_just_pressed("p1_b"):
		_explode_overlapping_evil()
	get_input()
	move_and_slide()

func _explode_overlapping_evil():
	for evil in get_tree().get_nodes_in_group("evil"):
		if evil.player_overlapping():
			evil.explode()
