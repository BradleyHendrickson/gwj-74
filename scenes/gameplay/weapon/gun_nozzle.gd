extends Node2D

@export var bullet_count = 1.00
@export var spread_mod = 1.00
@export var cooldown_mod = 1.00
@export var part_name = ""
@export var part_description = ""
@export var part_texture : Texture2D = null
@export var part_type = "nozzle"

func destroy():
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
