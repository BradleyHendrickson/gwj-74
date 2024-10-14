extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var reload_sound: AudioStreamPlayer2D = $ReloadSound

@onready var gun_core: Node2D = $GunCore

@export var ammo := 12
@onready var shoot_sound_1: AudioStreamPlayer2D = $ShootSound1
@export var max_ammo := 12
@export var uses_ammo := true
#@export var cooldown = 0.08
@export var auto = true
@export var smoke_amount = 1

var MUZZLE_DISTANCE = 22

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func isAuto():
	return auto

func shoot():
	if (ammo > 0 or !uses_ammo) && reload_timer.is_stopped() and !isReloading():
		ammo -= 1
		reload_timer.start(gun_core.cooldown)
		animated_sprite_2d.play("shoot")
		
		smoke_generator.smoke_direction_spread(smoke_amount, rotation, gun_core.spread, MUZZLE_DISTANCE)	
		shoot_sound_1.pitch_scale = 1 + randf_range(-0.05,0.05)
		shoot_sound_1.play()
		
		var rand_dir = randf_range(-deg_to_rad(gun_core.spread), deg_to_rad(gun_core.spread))
		var new_bullet = gun_core.bullet.instantiate()
		get_tree().root.add_child(new_bullet)
		new_bullet.transform = Transform2D( rotation  - rand_dir , global_position + Vector2(MUZZLE_DISTANCE * cos(rotation), MUZZLE_DISTANCE * sin(rotation)))

func isReloading():
	if animated_sprite_2d.animation == "spin_reload" and animated_sprite_2d.is_playing():
		return true
	else:
		return false
	
func reload():
	if !isReloading():
		reload_sound.play()
		animated_sprite_2d.stop()
		animated_sprite_2d.play("spin_reload")
		
		ammo = max_ammo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !animated_sprite_2d.is_playing():
		var oldfliph = animated_sprite_2d.flip_h
		animated_sprite_2d.play("default")
		animated_sprite_2d.flip_h = oldfliph
	pass
