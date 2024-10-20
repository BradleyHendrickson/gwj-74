extends Area2D

@export var friction = 700	
@export var speed = 550
@export var damage = 1
@onready var sprite_2d: Sprite2D = $Sprite2D

var damagable_targets: Array = []
var hit_count: int = 0  # Counter for how many enemies have been hit

@onready var timer = $Timer
@export var hitEffect : PackedScene

func longTime():
	timer.start(2)

func destroy():
	queue_free()

func die():
	# Uncomment if you want to instantiate a hit effect when dying
	# var f = hitEffect.instantiate()
	# get_tree().root.add_child(f)
	# f.position = position
	queue_free()

func _physics_process(delta):
	if timer.is_stopped():
		die()

	sprite_2d.scale = Vector2(1 + ((speed / 500) * 1.5), 1)

	position += transform.x * speed * delta
	
	# Check if the bullet has hit the maximum number of targets
	if hit_count >= 2:
		die()  # Destroy the bullet after hitting two enemies

func _on_body_entered(body):
	if body.has_method("hit"):
		if not damagable_targets.has(body):
			damagable_targets.append(body)
			body.hit(damage)  # Call the hit method
			hit_count += 1  # Increment the hit count
	else:
		die()

func _on_body_exited(body):
	if damagable_targets.has(body):
		damagable_targets.erase(body)
