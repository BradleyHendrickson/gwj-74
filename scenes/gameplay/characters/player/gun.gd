extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var reload_sound: AudioStreamPlayer2D = $ReloadSound
@onready var reload_start: AudioStreamPlayer2D = $ReloadStart
@onready var reload_finish: AudioStreamPlayer2D = $ReloadFinish

@onready var gun_core: Node2D = $GunCore
@onready var gun_magazine: Node2D = $GunMagazine
@onready var gun_nozzle: Node2D = $GunNozzle

@export var ammo : int = 0
@export var auto : bool = false
@export var uses_ammo : bool = true


@onready var shoot_sound_1: AudioStreamPlayer2D = $ShootSound1

#@export var cooldown = 0.08

@export var smoke_amount = 1

var MUZZLE_DISTANCE = 22

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo = gun_magazine.capacity 
	auto = gun_magazine.auto
	uses_ammo = gun_magazine.uses_ammo
	pass # Replace with function body.

func isAuto():
	return auto

func getCooldownTime():
	return gun_core.cooldown * gun_magazine.cooldown_mod

func getReloadTime():
	return 0.2222 * gun_magazine.reload_time_mod

func shoot():
	if (ammo > 0 or !uses_ammo) && reload_timer.is_stopped() and !isReloading():
		ammo -= 1
		reload_timer.start(getCooldownTime())
		#animated_sprite_2d.play("shoot")
		
		smoke_generator.smoke_direction_spread(smoke_amount, rotation, gun_core.spread, MUZZLE_DISTANCE)	
		shoot_sound_1.pitch_scale = 1 + randf_range(-0.05,0.05)
		shoot_sound_1.play()
		
		for i in gun_nozzle.bullet_count:
			
			var rand_dir = randf_range(-deg_to_rad(gun_core.spread), deg_to_rad(gun_core.spread))
			var new_bullet = gun_core.bullet.instantiate()
			get_tree().root.add_child(new_bullet)
			new_bullet.transform = Transform2D( rotation  - rand_dir , global_position + Vector2(MUZZLE_DISTANCE * cos(rotation), MUZZLE_DISTANCE * sin(rotation)))
			

func isReloading():
	if (animated_sprite_2d.animation == "spin_start" or animated_sprite_2d.animation=="spin_infinite" or animated_sprite_2d.animation=="spin_finish") and animated_sprite_2d.is_playing():
		return true
	else:
		return false
	
func reload():
	if !isReloading():
		reload_start.play()
		animated_sprite_2d.stop()
		#animated_sprite_2d.speed_scale = gun_magazine.reload_time_mod
		animated_sprite_2d.play("spin_start")
		
		ammo = gun_magazine.capacity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if reload_timer.is_stopped() and animated_sprite_2d.animation == "spin_infinite":
		reload_sound.stop()
		reload_finish.play()
		animated_sprite_2d.play("spin_finish")
	
	if !animated_sprite_2d.is_playing():
		if animated_sprite_2d.animation == "spin_start":
			reload_sound.play()
			reload_timer.start(getReloadTime())
			animated_sprite_2d.play("spin_infinite") 
		else:
			var oldfliph = animated_sprite_2d.flip_h
			animated_sprite_2d.play("default")
			animated_sprite_2d.flip_h = oldfliph

	pass
