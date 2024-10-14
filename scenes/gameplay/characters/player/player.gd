extends CharacterBody2D

@export var speed = 170
@export var friction = 0.2
@export var acceleration = 0.3
@onready var gun: Node2D = $Gun
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func get_input():
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
	if Input.is_action_pressed('move_left'):
		input.x -= 1
	if Input.is_action_pressed('move_down'):
		input.y += 1
	if Input.is_action_pressed('move_up'):
		input.y -= 1
	return input

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x > global_position.x:
		animated_sprite_2d.flip_h = false
		gun.scale = Vector2(1,1)
	else:
		gun.scale = Vector2(1,-1)
		animated_sprite_2d.flip_h = true
		
	var aim_dir = (mouse_pos - global_position).angle()
	gun.rotation = aim_dir
	
	if Input.is_action_pressed("shoot") and gun.isAuto():
		gun.shoot()
	
	if Input.is_action_just_pressed("shoot") and !gun.isAuto():
		gun.shoot()
		
	if Input.is_action_just_pressed("reload"):
		gun.reload()
	
		
func _physics_process(delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
