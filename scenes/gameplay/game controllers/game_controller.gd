extends Node2D

@onready var camera: Camera2D = $Camera
@onready var player = $Player
@export var health: int = 6
@onready var player_respawn_timer: Timer = $PlayerRespawnTier
@onready var game_music: AudioStreamPlayer2D = $GameMusic

@export var playerObject : PackedScene

var target_camera_position = Vector2(0,0)
@export var follow_smoothing = 8

@onready var debug_label: Label = $CanvasLayer/Control/DebugLabel

func _ready() -> void:
	game_music.play()
	#game_ui.setHealth(health)

func _process(delta):
	debug_label.text = player.getDebugLabel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_instance_valid(player):
		
		# Bias the camera towards the horizontal center of the screen
		var screen_center_x = 0.0
		target_camera_position.x = lerp(player.global_position.x, screen_center_x, 0.1) # Horizontal bias factor
		target_camera_position.y = player.global_position.y # Keep vertical alignment with the player
	else:
		if player_respawn_timer.is_stopped():
			var p = playerObject.instantiate()
			add_child(p)
			player = p
			health = 6
			p.position = Vector2(0, 56)
	
	# Smoothly move the camera towards the biased target position
	camera.global_position = camera.global_position.lerp(target_camera_position, delta * follow_smoothing)
