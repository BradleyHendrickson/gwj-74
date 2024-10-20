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

func getPrice() -> int:
	var base_price = price  # The initial price.
	var wave_factor = gamecontroller.wave_number  # Current wave number.
	
	# Linear scaling: increase price by 5 per wave.
	var linear_increase = wave_factor * 3

	# Calculate final price and return it as an integer.
	return int(base_price + linear_increase)


func currentlyUsed():
	if gamecontroller and my_item:
		if my_item.part_name == gamecontroller.player.gun.gun_core.part_name:
			sprite_check.visible = true
		elif my_item.part_name == gamecontroller.player.gun.gun_magazine.part_name:
			sprite_check.visible = true
		elif my_item.part_name == gamecontroller.player.gun.gun_nozzle.part_name:
			sprite_check.visible = true
		elif  gamecontroller.player.gun.gun_mod and my_item.part_name == gamecontroller.player.gun.gun_mod.part_name:
			sprite_check.visible = true
		elif gamecontroller.magnet == true and my_item.part_type == "magnet":
			sprite_check.visible = true
		else:
			sprite_check.visible = false
			
		equipped = sprite_check.visible

func getTooltip():
	if my_item:
		if !unlocked:
			return "Purchase? ($"+str(getPrice())+")" + "\n" + my_item.part_name + "\n" + my_item.part_description
		else:
			if equipped:
				return "(Equipped)" + "\n" + my_item.part_name + "\n" + my_item.part_description
			else:
				return my_item.part_name + "\n" + my_item.part_description
	else:
		return ""

func _process(delta: float) -> void:

	
	if Input.is_action_just_pressed('shoot') and hovering and my_item:
		if !unlocked:
			if gamecontroller.tears >= getPrice():
				gamecontroller.tears -= getPrice()
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
			elif my_item.part_type == "mod":
				gamecontroller.player.gun.swapMod(my_item)
				sound_equip.play()
			elif my_item.part_type == "magnet":
				equipped=true
				gamecontroller.magnet = true
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
