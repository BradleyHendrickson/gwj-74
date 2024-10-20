
extends CharacterBody2D

@onready var pickup_range: Area2D = $PickupRange
@onready var targets: Array
@onready var sprite_timer: Timer = $SpriteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var tears_count = 1
var gamecontroller = null	

var speed = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gamecontrollers = get_tree().get_nodes_in_group("gamecontroller")
	if gamecontrollers.is_empty():
		return
	else:
		gamecontroller = gamecontrollers[0]
	
	if gamecontroller and gamecontroller.magnet:
		# Assuming pickup_range is a Node2D that has a CollisionShape2D as a child
		var collision_shape = pickup_range.get_node("CollisionShape2D")  # Adjust the path if necessary
		
		if collision_shape:
			# Get the current scale of the CollisionShape2D
			var current_scale = collision_shape.scale
			
			# Double the size by scaling
			collision_shape.scale = current_scale * 3.0

		
	sprite_timer.start(randf_range(1,1.5))

func getTears():
	return tears_count

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
