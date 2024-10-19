extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func playsideclose():
	$AnimatedSprite2D.play("Sideclose")

func playtopclose():
	$AnimatedSprite2D.play("Topclose")
	
func playside():
	$AnimatedSprite2D.play("Sideclose")

func playtop():
	$AnimatedSprite2D.play("Topclose")
	
func setAnimation(animation):
	animated_sprite_2d.animation = animation
	if animation == "Side":
		collision_shape_2d.rotation = deg_to_rad(90)
		

func setFlip(flip : bool):
	animated_sprite_2d.flip_h = flip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
