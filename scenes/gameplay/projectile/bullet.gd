extends Area2D

@export var friction = 1000
@export var speed = 400
@export var damage = 1

var damagable_targets: Array

@onready var timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D

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

func _physics_process(delta):
	if timer.is_stopped():
		die()

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
