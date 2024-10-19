extends Node2D

@export var capacity = 6
@export var cooldown_mod = 1.1
@export var damage_mod = 1
@export var uses_ammo = true
@export var reload_time_mod = 1.00	
@export var part_name = ""
@export var part_description = ""


func destroy():
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
