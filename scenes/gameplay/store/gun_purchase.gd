extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var upgradeItem : PackedScene
@onready var sprite_check: Sprite2D = $SpriteCheck
@onready var sprite_dollar: Sprite2D = $SpriteDollar
@onready var sound_equip: AudioStreamPlayer2D = $SoundEquip

@export var price = 0
@export var unlocked = false
@onready var sound_buy: AudioStreamPlayer2D = $SoundBuy

var my_item
var equipped = false
var hovering = false
var gamecontroller = null	

func _ready():
	var gamecontrollers = get_tree().get_nodes_in_group("gamecontroller")
	if gamecontrollers.is_empty():
		return
	else:
		gamecontroller = gamecontrollers[0]
	
	if upgradeItem:
		my_item = upgradeItem.instantiate()
		sprite_2d.texture= my_item.part_texture

func currentlyUsed():
	if gamecontroller and my_item:
		if my_item.part_name == gamecontroller.player.gun.gun_core.part_name:
			sprite_check.visible = true
		elif my_item.part_name == gamecontroller.player.gun.gun_magazine.part_name:
			sprite_check.visible = true
		elif my_item.part_name == gamecontroller.player.gun.gun_nozzle.part_name:
			sprite_check.visible = true
		else:
			sprite_check.visible = false
			
		equipped = sprite_check.visible

func getTooltip():
	if my_item:
		if !unlocked:
			return "Purchase? ($"+str(price)+")" + "\n" + my_item.part_name + "\n" + my_item.part_description
		else:
			if equipped:
				return "(Equipped)" + "\n" + my_item.part_name + "\n" + my_item.part_description
			else:
				return my_item.part_name + "\n" + my_item.part_description
	else:
		return ""

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('shoot') and hovering:
		if !unlocked:
			if gamecontroller.tears >= price:
				gamecontroller.tears -= price
				unlocked = true
				sound_buy.play()
		elif !equipped:
			
			if my_item.part_type=="core":
				gamecontroller.player.gun.swapCore(my_item)
				sound_equip.play()
			elif my_item.part_type =="magazine":
				gamecontroller.player.gun.swapMagazine(my_item)
				sound_equip.play()
			elif my_item.part_type == "nozzle":
				gamecontroller.player.gun.swapNozzle(my_item)
				sound_equip.play()
			
	
	currentlyUsed()
	
	if unlocked:
		sprite_dollar.visible = false
	else:
		sprite_dollar.visible = true
	
	if hovering:
		animated_sprite_2d.play("hover")
	else:
		animated_sprite_2d.play("default")


func _on_area_2d_mouse_entered() -> void:
	hovering = true
	print("Mouse entered node")


func _on_area_2d_mouse_exited() -> void:
	hovering = false
	print("Mouse exited node")
