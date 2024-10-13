extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_generator: Node2D = $SmokeGenerator

const SPEED = 50
const JUMP_VELOCITY = -400.0

@onready var targets: Array

func _physics_process(delta: float) -> void:

	if len(targets) > 0:
		var follow = targets[0]
		var direction = follow.position -  position 
		var dir_vec = direction.normalized()
		velocity = dir_vec * SPEED

	if sign(velocity.x) > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
		targets.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
