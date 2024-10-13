extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var smoke_generator: Node2D = $SmokeGenerator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func shoot():
	print("shoot")
	animated_sprite_2d.play("shoot")
	smoke_generator.smoke_direction_spread(3, rotation, 30, 16)
	pass
	
func reload():
	animated_sprite_2d.stop()
	animated_sprite_2d.play("spin_reload")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
