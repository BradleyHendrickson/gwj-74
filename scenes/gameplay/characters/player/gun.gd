extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var cooldown_timer: Timer = $CooldownTimer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var reload_sound: AudioStreamPlayer2D = $ReloadSound
@onready var reload_start: AudioStreamPlayer2D = $ReloadStart
@onready var reload_finish: AudioStreamPlayer2D = $ReloadFinish
@onready var sound_gun_empty: AudioStreamPlayer2D = $SoundGunEmpty

@onready var gun_core: Node2D = $GunCore
@onready var gun_magazine: Node2D = $GunMagazine
@onready var gun_nozzle: Node2D = $GunNozzle

@export var ammo : int = 0
@export var auto : bool = false
@export var uses_ammo : bool = true

@export var GunCorePistol : PackedScene
@export var GunCoreShotgun : PackedScene

@export var GunMagazineSmall : PackedScene
@export var GunMagazineLarge : PackedScene

@export var GunNozzleAccurate : PackedScene
@export var GunNozzleSpray : PackedScene
@export var GunNozzleShotgun : PackedScene

@export var currGunCore = 'pistol'
@export var currGunMagazine = 'small'
@export var currGunNozzle = 'accurate'


@onready var shoot_sound_1: AudioStreamPlayer2D = $ShootSound1

#@export var cooldown = 0.08

@export var smoke_amount = 1
@export var was_stopped = true

var MUZZLE_DISTANCE = 22

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo = gun_magazine.capacity 
	auto = false
	uses_ammo = gun_magazine.uses_ammo
	pass # Replace with function body.

func isAuto():
	return auto

func getCooldownTime():
	return gun_core.cooldown * gun_magazine.cooldown_mod * gun_nozzle.cooldown_mod

func getReloadTime():
	return 0.2222 * gun_magazine.reload_time_mod

func getSpread():
	return gun_core.spread * gun_nozzle.spread_mod
	
func shoot():
	if (ammo > 0 or !uses_ammo) && reload_timer.is_stopped() && cooldown_timer.is_stopped() and !isReloading():
		ammo -= 1
		cooldown_timer.start(getCooldownTime())
		#animated_sprite_2d.play("shoot")
		
		smoke_generator.smoke_direction_spread(smoke_amount, rotation, getSpread(), MUZZLE_DISTANCE)	
		shoot_sound_1.pitch_scale = 1 + randf_range(-0.05,0.05)
		shoot_sound_1.play()
		
		for i in gun_nozzle.bullet_count:
			var actualSpread = getSpread()
			var rand_dir = randf_range(-deg_to_rad(actualSpread), deg_to_rad(actualSpread))
			var new_bullet = gun_core.bullet.instantiate()
			get_tree().root.add_child(new_bullet)
			new_bullet.transform = Transform2D( rotation  - rand_dir , global_position + Vector2(MUZZLE_DISTANCE * cos(rotation), MUZZLE_DISTANCE * sin(rotation)))
		

func isReloading():
	if (animated_sprite_2d.animation == "spin_start" or animated_sprite_2d.animation=="spin_infinite") and animated_sprite_2d.is_playing():
		return true
	else:
		return false
	
func reload():
	if !isReloading():
		reload_start.pitch_scale = 1
		reload_start.play()
		#reload_finish.play()
		animated_sprite_2d.stop()
		#animated_sprite_2d.speed_scale = gun_magazine.reload_time_mod
		animated_sprite_2d.play("spin_start")
		
		ammo = gun_magazine.capacity

func getDebugLabel():
	var is_auto = str(isAuto())
	var cool_time = str(getCooldownTime())
	var reload_time = str(getReloadTime())
	var actual_spread = str(getSpread())

	return """	
				Use (J, K, L, ") to swap components
	
				Core: %s
				Magazine: %s
				Nozzle: %s
				Auto: %s

				[Current Build Stats]
				Cooldown: %s * %s * %s = %s
				Reload Time: 0.2222 * %s = %s
				Spread: %s * %s = %s
				
				""" % [
						currGunCore, currGunMagazine, currGunNozzle, str(auto),
						gun_core.cooldown , gun_magazine.cooldown_mod , gun_nozzle.cooldown_mod ,
						cool_time, gun_magazine.reload_time_mod ,reload_time, gun_core.spread , gun_nozzle.spread_mod, actual_spread
						
	]


func swapCore(newCore):
	gun_core.queue_free()  # Free the current core
	var newGunCore = newCore.duplicate()  # Create a clone of newCore
	gun_core = newGunCore  # Assign the new clone to gun_core
	add_child(gun_core)  # Add the new core to the scene tree

func swapMagazine(newMag):
	ammo = 0
	gun_magazine.queue_free()  # Free the current core
	var newGunMag = newMag.duplicate()  # Create a clone of newCore
	gun_magazine = newGunMag  # Assign the new clone to gun_core
	add_child(gun_magazine)  # Add the new core to the scene tree

func swapNozzle(newNozzle):
	gun_nozzle.queue_free()  # Free the current core
	var newGunNozzle = newNozzle.duplicate()   # Create a clone of newCore
	gun_nozzle = newGunNozzle  # Assign the new clone to gun_core
	add_child(gun_nozzle)  # Add the new core to the scene tree

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and !get_parent().is_paused:
		if ammo <= 0 and !isReloading():
			sound_gun_empty.play()
			smoke_generator.smoke_direction_spread(smoke_amount, rotation, getSpread(), MUZZLE_DISTANCE)	

	
	if Input.is_action_just_pressed("debug_swap_core"):
		print(currGunCore)
		if currGunCore == 'pistol':
			gun_core.queue_free()
			var newGunCore = GunCoreShotgun.instantiate()
			gun_core = newGunCore
			currGunCore = 'shotgun'
		elif currGunCore == 'shotgun':
			gun_core.queue_free()
			var newGunCore = GunCorePistol.instantiate()
			gun_core = newGunCore
			currGunCore = 'pistol'
			
	if Input.is_action_just_pressed("debug_swap_magazine"):
		print(currGunMagazine)
		if currGunMagazine == 'small':
			gun_magazine.queue_free()
			var newGunMagazine = GunMagazineLarge.instantiate()
			gun_magazine = newGunMagazine
			currGunMagazine = 'large'
		elif currGunMagazine == 'large':
			gun_magazine.queue_free()
			var newGunMagazine = GunMagazineSmall.instantiate()
			gun_magazine = newGunMagazine
			currGunMagazine = 'small'
	
	if Input.is_action_just_pressed("debug_swap_nozzle"):
		print(currGunMagazine)
		if currGunNozzle == 'accurate':
			gun_nozzle.queue_free()
			var newGunNozzle = GunNozzleSpray.instantiate()
			gun_nozzle = newGunNozzle
			currGunNozzle = 'spray'
		elif currGunNozzle == 'spray':
			gun_nozzle.queue_free()
			var newGunNozzle = GunNozzleShotgun.instantiate()
			gun_nozzle = newGunNozzle
			currGunNozzle= 'shotgun'
		elif currGunNozzle == 'shotgun':
			gun_nozzle.queue_free()
			var newGunNozzle = GunNozzleAccurate.instantiate()
			gun_nozzle = newGunNozzle
			currGunNozzle= 'accurate'
			
	if Input.is_action_just_pressed("debug_swap_auto"):
		auto = !auto
	
	if !was_stopped and cooldown_timer.is_stopped():
		gun_core.cooldownSound()
	was_stopped= cooldown_timer.is_stopped()
	
	if reload_timer.is_stopped() and animated_sprite_2d.animation == "spin_infinite":
		reload_sound.stop()
		reload_finish.play()
		#reload_start.play()
		animated_sprite_2d.play("spin_finish")
	
	if !animated_sprite_2d.is_playing():
		if animated_sprite_2d.animation == "spin_start":
			reload_sound.pitch_scale = 1 + randf_range(-0.05,0.05)
			reload_sound.play()
			reload_timer.start(getReloadTime())
			animated_sprite_2d.play("spin_infinite") 
		else:
			var oldfliph = animated_sprite_2d.flip_h
			animated_sprite_2d.play("default")
			animated_sprite_2d.flip_h = oldfliph

	pass
