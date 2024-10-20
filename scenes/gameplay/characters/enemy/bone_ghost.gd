extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_generator: Node2D = $SmokeGenerator

@export var speed = 50 # Speed of the enemy
const JUMP_VELOCITY = -400.0
@export var health = 5

@onready var area_2d: Area2D = $Area2D
@onready var area_2d_2: Area2D = $Area2D2
@onready var area_2d_3: Area2D = $Area2D3

@onready var targets: Array = []
@export var GhostTear: PackedScene
@onready var sound_hit: AudioStreamPlayer2D = $SoundHit
var dead = false
@export var die_effect: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box: Area2D = $HurtBox
var hit_targets = []

signal death

@export var dead_zone_radius = 50.0 # Distance to stay still
@export var safe_distance = 80.0 # Distance to start moving away from the player

var state = "idle" # States: "idle", "approaching", "retreating"

func setShader(value):
	animated_sprite_2d.material.set("shader_param/active", value)

func die():
	dead = true
	var x = GhostTear.instantiate()
	get_tree().root.add_child(x)
	x.position = global_position
	
	var y = die_effect.instantiate()
	get_tree().root.add_child(y)
	y.position = global_position
	
	emit_signal("death")
	smoke_generator.smoke(4)
	print("good")
	queue_free()

func hit(damage):
	animation_player.play("hit")
	sound_hit.play()
	health -= damage
	if health <= 0 and !dead:
		die()    

func _ready():
	speed += randf_range(0, 10)

func _process(delta):
	for tar in hit_targets:
		tar.hit()

func _physics_process(delta: float) -> void:
	var player_position = Vector2.ZERO
	
	if len(targets) > 0:
		player_position = targets[0].position
		var direction = player_position - position
		var distance_to_player = direction.length()
		direction = direction.normalized()

		# Check which state to be in based on the player's distance
		if area_2d_2 and area_2d_2.overlaps_body(targets[0]):
			state = "retreating" # Player is in Area2D2, retreat
		elif area_2d_3 and area_2d_3.overlaps_body(targets[0]):
			state = "retreating" # Player is in Area2D3, retreat
		elif distance_to_player > dead_zone_radius and distance_to_player <= safe_distance:
			state = "approaching" # Player is outside the dead zone but inside the safe distance
		else:
			state = "idle" # Player is in dead zone or too far

		# Handle movement based on the state
		match state:
			"approaching":
				velocity = direction * speed
			"retreating":
				velocity = -direction * speed
			"idle":
				velocity = Vector2.ZERO

		# Update the flip_h property only when approaching
		if state == "approaching":
			animated_sprite_2d.flip_h = sign(velocity.x) < 0
		else:
			animated_sprite_2d.flip_h = false # Reset to default when idle or retreating

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	targets.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		hit_targets.append(body)

func _on_hurt_box_body_exited(body: Node2D) -> void:
	if (hit_targets.has(body)):
		hit_targets.erase(body)

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	# Optional: Logic for entering Area2D2
	pass

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	# Optional: Logic for exiting Area2D2
	pass

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	# Optional: Logic for entering Area2D3
	pass

func _on_area_2d_3_body_exited(body: Node2D) -> void:
	# Optional: Logic for exiting Area2D3
	pass
