
extends Node2D


@onready var sprite_timer: Timer = $SpriteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_timer.start(randf_range(1,1.5))

func tear_pickup():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	if !animated_sprite_2d.is_playing() and animated_sprite_2d.animation== "shine":
		animated_sprite_2d.animation = "default"	


func _on_sprite_timer_timeout() -> void:
	print("finished")
	animated_sprite_2d.play("shine")
	sprite_timer.start(randf_range(1,1.5))
