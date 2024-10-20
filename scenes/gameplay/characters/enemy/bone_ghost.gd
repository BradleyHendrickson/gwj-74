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
@onready var timer: Timer = $Timer
@onready var shot_timer: Timer = $ShotTimer
@export var my_bullet : PackedScene
signal death
@onready var throw_bone: AudioStreamPlayer2D = $ThrowBone

@export var dead_zone_radius = 50.0 # Distance to stay still
@export var safe_distance = 80.0 # Distance to start moving away from the player
@export var MUZZLE_DISTANCE = 10.0 # Distance from the enemy to spawn the bullet

var state = "idle" # States: "idle", "approaching", "retreating"

func setShader(value):
	animated_sprite_2d.material.set("shader_param/active", value)

func shoot():
	if !dead and len(targets) > 0:
		throw_bone.play()
		var bullet = my_bullet.instantiate()
		var direction = (targets[0].position - global_position).normalized()
		var rotation = direction.angle()
		var rand_dir = randf_range(-0.05, 0.05) # Randomness for bullet direction

		# Set the bullet's transform based on the rotation and muzzle distance
		bullet.transform = Transform2D(rotation - rand_dir, global_position + Vector2(MUZZLE_DISTANCE * cos(rotation), MUZZLE_DISTANCE * sin(rotation)))
		get_tree().root.add_child(bullet)
		shot_timer.start(2 + randf_range(-0.2,0.2))

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
	timer.wait_time = 0.5 # Set the timer wait time to 0.5 seconds
	timer.connect("timeout", Callable(self, "_on_timer_timeout").bind(timer))
	timer.start() # Start the timer immediately

	shot_timer.wait_time = 1.0 # Set the shot timer wait time to 1 second
	shot_timer.connect("timeout", Callable(self, "shoot"))
	shot_timer.start() # Start the shot timer immediately

func _process(delta):
	for tar in hit_targets:
		tar.hit()

func _physics_process(delta: float) -> void:
	if len(targets) > 0:
		var player_position = targets[0].position
		var direction = player_position - position
		var distance_to_player = direction.length()
		direction = direction.normalized()

		# Check for player in area2d_2 or area2d_3
		if area_2d_2 and area_2d_2.overlaps_body(targets[0]):
			update_state("retreating")
		elif area_2d_3 and area_2d_3.overlaps_body(targets[0]):
			update_state("retreating")
		elif distance_to_player > dead_zone_radius and distance_to_player <= safe_distance:
			update_state("approaching")
		elif distance_to_player > safe_distance:
			update_state("approaching")
		else:
			update_state("idle")

		# Handle movement based on the state
		match state:
			"approaching":
				velocity = direction * speed
			"retreating":
				velocity = -direction * speed
			"idle":
				velocity = Vector2.ZERO

		# Update the flip_h property only when approaching
		animated_sprite_2d.flip_h = state == "approaching" && sign(velocity.x) < 0

		move_and_slide()

func update_state(new_state: String):
	if timer.is_stopped(): # Only update the state if the timer is stopped
		state = new_state
		timer.start() # Restart the timer when the state changes

func _on_timer_timeout():
	# The timer will automatically be restarted in update_state
	pass

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
