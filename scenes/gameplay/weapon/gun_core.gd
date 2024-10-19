extends Node2D

@onready var cooldown_sound: AudioStreamPlayer2D = $CooldownSound
@onready var shoot_sound_1: AudioStreamPlayer2D = $ShootSound1
@export var bullet : PackedScene
@export var spread  = 5
@export var cooldown = 0.08
@export var use_cooldown_sound = false
@export var part_name = ""
@export var part_description = ""
@export var part_texture : Texture2D = null
@export var part_type = "core"

func destroy():
	queue_free()

func shootSound():
	shoot_sound_1.play()

func cooldownSound():
	if use_cooldown_sound:
		cooldown_sound.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
