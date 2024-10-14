extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var reload_sound: AudioStreamPlayer2D = $ReloadSound
@onready var shoot_sound_1: AudioStreamPlayer2D = $ShootSound1
@export var bullet : PackedScene

var MUZZLE_DISTANCE = 22

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func shoot():
	print("shoot")
	animated_sprite_2d.play("shoot")
	smoke_generator.smoke_direction_spread(1, rotation, 5, MUZZLE_DISTANCE)	
	shoot_sound_1.pitch_scale = 1 + randf_range(-0.05,0.05)
	shoot_sound_1.play()
	
	var new_bullet = bullet.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.transform = Transform2D( rotation , global_position + Vector2(MUZZLE_DISTANCE * cos(rotation), MUZZLE_DISTANCE * sin(rotation)))

	
func reload():
	reload_sound.play()
	animated_sprite_2d.stop()
	animated_sprite_2d.play("spin_reload")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !animated_sprite_2d.is_playing():
		var oldfliph = animated_sprite_2d.flip_h
		animated_sprite_2d.play("default")
		animated_sprite_2d.flip_h = oldfliph
	pass
