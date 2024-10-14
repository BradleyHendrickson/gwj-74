extends Node2D

@onready var shoot_sound_1: AudioStreamPlayer2D = $ShootSound1
@export var bullet : PackedScene
@export var spread  = 5
@export var cooldown = 0.08

func shootSound():
	shoot_sound_1.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
