extends Node2D

var hovering = false
	
# Called when the mouse enters the Area2D
func _on_mouse_entered() -> void:
	hovering = true
	print("Mouse entered node")

# Called when the mouse leaves the Area2D
func _on_mouse_exited() -> void:
	hovering = false
	print("Mouse exited node")

# Optional: If you need to detect specific click events
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked on the node")
