extends Control

@onready var mouse_tool_tip: Label = $MouseToolTip

@onready var gun_core_config: Node2D = $GunModder/GunCoreConfig
@onready var gun_magazine_config: Node2D = $GunModder/GunMagazineConfig
@onready var gun_nozzle_config: Node2D = $GunModder/GunNozzleConfig

@onready var gun_attachment_1_config: Node2D = $GunModder/GunAttachment1Config
@onready var gun_attachment_2_config: Node2D = $GunModder/GunAttachment2Config

@onready var gun_purchase: Node2D = $GunBuyer/GunPurchase
@onready var gun_purchase_2: Node2D = $GunBuyer/GunPurchase2
@onready var gun_purchase_3: Node2D = $GunBuyer/GunPurchase3
@onready var gun_purchase_4: Node2D = $GunBuyer/GunPurchase4
@onready var gun_purchase_5: Node2D = $GunBuyer/GunPurchase5
@onready var gun_purchase_6: Node2D = $GunBuyer/GunPurchase6
@onready var gun_purchase_7: Node2D = $GunBuyer/GunPurchase7
@onready var gun_purchase_8: Node2D = $GunBuyer/GunPurchase8
@onready var gun_purchase_9: Node2D = $GunBuyer/GunPurchase9
@onready var gun_purchase_10: Node2D = $GunBuyer/GunPurchase10
@onready var gun_purchase_11: Node2D = $GunBuyer/GunPurchase11
@onready var gun_purchase_12: Node2D = $GunBuyer/GunPurchase12

@onready var tears_count_label: Label = $TearsCount


var gamecontroller
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gamecontrollers = get_tree().get_nodes_in_group("gamecontroller")
	if gamecontrollers.is_empty():
		return
	else:
		gamecontroller = gamecontrollers[0]
	

func updateGunTexture():
	gun_core_config.updateTexture(gamecontroller.player.gun.gun_core.part_texture)
	gun_magazine_config.updateTexture(gamecontroller.player.gun.gun_magazine.part_texture)
	gun_nozzle_config.updateTexture(gamecontroller.player.gun.gun_nozzle.part_texture)
	pass
	#if gamecontroller.player.gun.gun_core.part_name == "Pistol Core":
	#if gamecontroller.player.gun.gun_core.part_name == "Shotgun Core":
	

func updateTooltip():
	var tipText = ""
	if gun_purchase.hovering:
		tipText = gun_purchase.getTooltip()
	if gun_purchase_2.hovering:
		tipText = gun_purchase_2.getTooltip()
	if gun_purchase_3.hovering:
		tipText = gun_purchase_3.getTooltip()
	if gun_purchase_4.hovering:
		tipText = gun_purchase_4.getTooltip()
	if gun_purchase_5.hovering:
		tipText = gun_purchase_5.getTooltip()
	if gun_purchase_6.hovering:
		tipText = gun_purchase_6.getTooltip()
	if gun_purchase_7.hovering:
		tipText = gun_purchase_7.getTooltip()
	if gun_purchase_8.hovering:
		tipText = gun_purchase_8.getTooltip()
	if gun_purchase_9.hovering:
		tipText = gun_purchase_9.getTooltip()
	if gun_purchase_10.hovering:
		tipText = gun_purchase_10.getTooltip()
	if gun_purchase_11.hovering:
		tipText = gun_purchase_11.getTooltip()
	if gun_purchase_12.hovering:
		tipText = gun_purchase_12.getTooltip()
		
	if gun_core_config.hovering:
		tipText = gamecontroller.player.gun.gun_core.part_name + "\n" + gamecontroller.player.gun.gun_core.part_description
	if gun_magazine_config.hovering:
		tipText = gamecontroller.player.gun.gun_magazine.part_name + "\n" + gamecontroller.player.gun.gun_magazine.part_description
	if gun_nozzle_config.hovering:
		tipText = gamecontroller.player.gun.gun_nozzle.part_name + "\n" + gamecontroller.player.gun.gun_nozzle.part_description
	
	mouse_tool_tip.text = tipText
	
	# Get the mouse position relative to the current viewport
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Update the tooltip's position to follow the mouse
	mouse_tool_tip.position = mouse_pos + Vector2(16,16)
	
	if tipText == "" or !tipText:
		mouse_tool_tip.visible = false
	else:
		mouse_tool_tip.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateTooltip()
	updateGunTexture()
	tears_count_label.text = "Ghost Tears: " + str(gamecontroller.tears)

func _on_button_button_down() -> void:
	if gamecontroller:
		gamecontroller.shopTransitionOut()
	
