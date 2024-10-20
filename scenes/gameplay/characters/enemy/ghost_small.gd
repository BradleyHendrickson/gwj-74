extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_generator: Node2D = $SmokeGenerator

@export var speed = 50 #50
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
	if len(targets) > 0:
		var follow = targets[0]
		var direction = follow.position - position
		var dir_vec = direction.normalized()

		# Check if the player is in Area2D2 or Area2D3
		if area_2d_2.overlaps_body(follow):
			# Player is in Area2D2, move away
			velocity = -dir_vec * speed
		elif area_2d_3.overlaps_body(follow):
			# Player is in Area2D3, also move away
			velocity = -dir_vec * speed
		else:
			# Move towards the player
			velocity = dir_vec * speed

	if sign(velocity.x) > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true

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
	# You may want to handle logic here when entering Area2D2
	pass

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	# You may want to handle logic here when exiting Area2D2
	pass

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	# You may want to handle logic here when entering Area2D3
	pass

func _on_area_2d_3_body_exited(body: Node2D) -> void:
	# You may want to handle logic here when exiting Area2D3
	pass
