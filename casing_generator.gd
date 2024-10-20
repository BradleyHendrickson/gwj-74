extends Node2D

@export var casing : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func casingspawn(casing_amount):
	# Use call_deferred to handle the smoke instantiation after the current processing
	call_deferred("_spawn_casing", casing_amount, get_parent().position )

func casing_direction_spread(amount, direction, offset_angle, distance):
	call_deferred("_spawn_casing_direction_random", amount, get_parent().position , direction, offset_angle, distance)

func casing_at_position(amount, pos):
	# Use call_deferred to handle the smoke instantiation after the current processing
	call_deferred("_spawn_casing", amount, pos)

func _spawn_casing_direction_random(amount, pos, direction, offset_angle, distance):
	for i in range(amount):
		var x = casing.instantiate()
		get_tree().root.add_child(x)


		# Get a random angle offset in radians
		var random_offset = deg_to_rad(randf_range(-offset_angle, offset_angle))
		
		
		# Rotate the direction vector by the random angle
		var new_direction = direction + random_offset
		x.position = get_parent().global_position + Vector2(distance * cos(new_direction), distance * sin(new_direction ))
		# Assign the new direction to the particle
		x.moveDir(new_direction)


func _spawn_casing(amount, pos):
	for i in range(amount):
		var x = casing.instantiate()
		get_tree().root.add_child(x)
		x.position = pos 
		x.moveRand()
