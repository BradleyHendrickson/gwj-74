extends Control

@onready var mouse_tool_tip: Label = $MouseToolTip

@onready var gun_core_config: Node2D = $GunModder/GunCoreConfig
@onready var gun_magazine_config: Node2D = $GunModder/GunMagazineConfig
@onready var gun_nozzle_config: Node2D = $GunModder/GunNozzleConfig
@onready var gun_attachment_1_config: Node2D = $GunModder/GunAttachment1Config
@onready var gun_attachment_2_config: Node2D = $GunModder/GunAttachment2Config

var gamecontroller
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gamecontrollers = get_tree().get_nodes_in_group("gamecontroller")
	if gamecontrollers.is_empty():
		return
	else:
		gamecontroller = gamecontrollers[0]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_tool_tip.text = gamecontroller.player.gun.gun_core.part_name + "\n" + gamecontroller.player.gun.gun_core.part_description
	
	# Get the mouse position relative to the current viewport
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Update the tooltip's position to follow the mouse
	mouse_tool_tip.position = mouse_pos + Vector2(16,16)
	
	

func _on_button_button_down() -> void:
	if gamecontroller:
		gamecontroller.shopTransitionOut()
	
