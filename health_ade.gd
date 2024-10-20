extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var hovering = false
var gamecontroller = null	
@onready var sound_buy: AudioStreamPlayer2D = $SoundBuy
@onready var area_2d: Area2D = $Area2D

func _ready():
	var gamecontrollers = get_tree().get_nodes_in_group("gamecontroller")
	if gamecontrollers.is_empty():
		return
	else:
		gamecontroller = gamecontrollers[0]

# Optional: If you need to detect specific click events
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked on the node")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('shoot') and hovering:
		if gamecontroller.tears >= getPrice():
			gamecontroller.tears -= getPrice()
			gamecontroller.health = 6
			sound_buy.play()
			gamecontroller.heal_count += 1
	
	if hovering:
		animated_sprite_2d.play("hover")
	else:
		animated_sprite_2d.play("default")

func getPrice():
	if gamecontroller:
		return 20 * gamecontroller.heal_count
	else:
		return 0

func getTooltip():
	return "Purchase? ($"+str(getPrice())+")" + "\n" + "Health-Ade" + "\n" + "Mysterious healing brew. Drink it?"

func _on_area_2d_mouse_entered() -> void:
	hovering = true



func _on_area_2d_mouse_exited() -> void:
	hovering = false
