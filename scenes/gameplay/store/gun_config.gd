extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var hovering = false
	


# Optional: If you need to detect specific click events
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked on the node")

func _process(delta: float) -> void:
	if hovering:
		animated_sprite_2d.play("hover")
	else:
		animated_sprite_2d.play("default")

func updateTexture(texture):
	sprite_2d.texture = texture

func _on_area_2d_mouse_entered() -> void:
	hovering = true



func _on_area_2d_mouse_exited() -> void:
	hovering = false
