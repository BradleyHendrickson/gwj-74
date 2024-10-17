extends Node2D

@onready var camera: Camera2D = $Camera
@onready var player = $Player
@export var health: int = 6
@onready var player_respawn_timer: Timer = $PlayerRespawnTier
@onready var game_music: AudioStreamPlayer2D = $GameMusic

@export var RoomHeight =360
@export var RoomWidth = 640


@export var playerObject : PackedScene

var target_camera_position = Vector2(0,0)
@export var follow_smoothing = 8

@onready var debug_label: Label = $CanvasLayer/Control/DebugLabel

func get_room_center(player_position : Vector2) -> Vector2:
	var room_x = floor(player_position.x / RoomWidth) * RoomWidth 
	var room_y = floor(player_position.y / RoomHeight) * RoomHeight
	var room_center = Vector2(room_x + RoomWidth / 2, room_y + RoomHeight / 2)
	return room_center

func _ready() -> void:
	game_music.play()
	#game_ui.setHealth(health)

func _process(delta):
	debug_label.text = player.getDebugLabel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	target_camera_position = Vector2(0,0)
	
	if is_instance_valid(player):
		# Calculate the room center based on the player's position
		var room_center = get_room_center(player.global_position)
		
		# Bias the camera slightly toward the player's position
		var bias_factor = 0.2  # Adjust this for more or less bias
		target_camera_position = lerp(room_center, player.global_position, bias_factor)
		
	else:
		# Respawn the player if the respawn timer is stopped
		if player_respawn_timer.is_stopped():
			var p = playerObject.instantiate()
			add_child(p)
			player = p
			health = 6
			p.position = Vector2(0, 56)
	
	# Smoothly move the camera towards the biased target position
	camera.global_position = camera.global_position.lerp(target_camera_position, delta * follow_smoothing)
