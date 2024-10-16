extends Area2D

@export var friction = 700	
@export var speed = 400	
@export var damage = 1
@onready var sprite_2d: Sprite2D = $Sprite2D



var damagable_targets: Array

@onready var timer = $Timer
@export var hitEffect : PackedScene

func longTime():
	timer.start(2)

func destroy():
	queue_free()

func die():
	#var f = hitEffect.instantiate()
	#get_tree().root.add_child(f)
	#f.position = position
	queue_free()

#func _ready() -> void:
	#speed = speed * randf_range(0.7,1.1)

func _physics_process(delta):
	
	
	if timer.is_stopped():
		die()

	#sprite_2d.scale = Vector2(1 + ((speed/500) * 1.5), 1)

	#speed = speed - friction * delta
	#if speed < 0:
	#	speed = 0
	
	#if speed == 0:
	#	destroy()

	position += transform.x * speed * delta
	
	for t in damagable_targets:
		t.hit(damage)

func _on_body_entered(body):
	if body.has_method("hit"):
		damagable_targets.append(body)
	die()

func _on_body_exited(body):
	if (damagable_targets.has(body)):
		damagable_targets.erase(body)
