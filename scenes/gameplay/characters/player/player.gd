extends CharacterBody2D

@export var speed = 170
@export var friction = 0.2
@export var acceleration = 0.3
@onready var gun: Node2D = $Gun
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_area_2d: Area2D = $PickupArea2D
@onready var sound_get_tear: AudioStreamPlayer2D = $SoundGetTear
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_player_hit: AudioStreamPlayer2D = $SoundPlayerHit
@onready var hit_cooldown_timer: Timer = $HitCooldownTimer

var targets : Array = []
var buffer_time = 0.1  # 0.1 second buffer window
var can_shoot = true  # Controls if a shot can happen within the buffer
var is_paused = false

func hit():
	if hit_cooldown_timer.is_stopped():
		get_parent().health -= 1
		sound_player_hit.pitch_scale = 1 + randf_range(-0.1	,0.1)
		animation_player.play("hit")
		sound_player_hit.play()
		hit_cooldown_timer.start(0.6)

func pause():
	visible = false
	is_paused = true
	
func unpause():
	visible = true
	is_paused = false

func setShader(value):
	animated_sprite_2d.material.set("shader_param/active", value)

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
	if Input.is_action_pressed('move_left'):
		input.x -= 1
	if Input.is_action_pressed('move_down'):
		input.y += 1
	if Input.is_action_pressed('move_up'):
		input.y -= 1
	return input

func getDebugLabel():
	return gun.getDebugLabel()

func _process(delta):
	if is_paused:
		return
	
	var got = false
	for target in targets:
		got = true
		target.tear_pickup()
		get_parent().tears += 1
	if got:
		sound_get_tear.play()
		
	
	animated_sprite_2d.speed_scale = (abs(velocity.length())/speed) * 1.2
	
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x > global_position.x:
		animated_sprite_2d.flip_h = false
		gun.scale = Vector2(1,1)
	else:
		gun.scale = Vector2(1,-1)
		animated_sprite_2d.flip_h = true
		
	var aim_dir = (mouse_pos - global_position).angle()
	gun.rotation = aim_dir
	
	if Input.is_action_pressed("shoot") and gun.isAuto():
		gun.shoot()
	
	if Input.is_action_just_pressed("shoot") and !gun.isAuto():
		if can_shoot:
			gun.shoot()
			can_shoot = false  # Disable shooting temporarily
			start_shoot_buffer()  # Start the buffer timer
		
	if Input.is_action_just_pressed("reload"):
		gun.reload()
	
func start_shoot_buffer() -> void:
	await get_tree().create_timer(buffer_time).timeout  # Await the timer completion
	can_shoot = true  # Re-enable shooting after the buffer expires
		
func _physics_process(delta):
	if is_paused:
		return
	
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()


func _on_pickup_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("tear_pickup"):
		targets.append(body)

func _on_pickup_area_2d_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
