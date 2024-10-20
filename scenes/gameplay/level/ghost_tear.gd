
extends CharacterBody2D

@onready var pickup_range: Area2D = $PickupRange
@onready var targets: Array
@onready var sprite_timer: Timer = $SpriteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var speed = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_timer.start(randf_range(1,1.5))

func tear_pickup():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(targets) > 0:
		var follow = targets[0]
		var direction = follow.position -  position 
		var dir_vec = direction.normalized()
		velocity = dir_vec * speed
	
	move_and_slide()
	pass
	if !animated_sprite_2d.is_playing() and animated_sprite_2d.animation== "shine":
		animated_sprite_2d.animation = "default"	


func _on_sprite_timer_timeout() -> void:
	print("finished")
	animated_sprite_2d.play("shine")
	sprite_timer.start(randf_range(1,1.5))


func _on_pickup_range_body_entered(body: Node2D) -> void:
	targets.append(body)


func _on_pickup_range_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
