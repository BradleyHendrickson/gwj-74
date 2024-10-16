extends Node2D

@onready var camera: Camera2D = $Camera
@onready var player = $Player
@export var health: int = 6
@onready var player_respawn_timer: Timer = $PlayerRespawnTier
@onready var game_music: AudioStreamPlayer2D = $GameMusic

@onready var vignette: Sprite2D = $Vignette

@export var RoomHeight =352
@export var RoomWidth = 640

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

@export var playerObject : PackedScene

var target_camera_position = Vector2(0,0)
@export var follow_smoothing = 8

@onready var debug_label: Label = $CanvasLayer/Control/DebugLabel

@onready var room_info_label: Label = $CanvasLayer/Control/RoomInfoLabel
@onready var wave_timer: Timer = $WaveTimer
@onready var entered_room_timer: Timer = $EnteredRoomTimer

@export var LockedDoor: PackedScene
@export var SmallGhost : PackedScene
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var sound_door_open: AudioStreamPlayer2D = $SoundDoorOpen
@onready var sound_door_close: AudioStreamPlayer2D = $SoundDoorClose

@onready var color_rect: ColorRect = $ColorRect
@onready var wave_end_timer: Timer = $WaveEndTimer
@onready var sound_wave_finished_bell: AudioStreamPlayer2D = $SoundWaveFinishedBell
@onready var wave_finished_sound_timer: Timer = $WaveFinishedSoundTimer

var targets : Array = []


var reset_collision = false
var wave_number = 0
var enemies : Array = []
var in_room = Vector2(0,0)
var room_finished : bool = true
var doors : Array = []

var end_room_center = Vector2(0,0)

func get_room_center(player_position : Vector2) -> Vector2:
	var room_x = floor(player_position.x / RoomWidth) * RoomWidth 
	var room_y = floor(player_position.y / RoomHeight) * RoomHeight
	var room_center = Vector2(room_x + RoomWidth / 2, room_y + RoomHeight / 2)
	return room_center

func _ready() -> void:
	game_music.play()
	#game_ui.setHealth(health)

func entered_room(room_center : Vector2):
	sound_door_close.play()
	area_2d.monitoring= false
	targets = []

	in_room = room_center
	room_finished = false
	#lock the doors!
	var d = LockedDoor.instantiate()
	var d2 = LockedDoor.instantiate()
	var d3 = LockedDoor.instantiate()
	var d4 = LockedDoor.instantiate()
	add_child(d)
	add_child(d2)
	add_child(d3)
	add_child(d4)
	d.position = room_center - Vector2(RoomWidth/2, 0)
	d2.position = room_center + Vector2(RoomWidth/2, 0)
	d3.position = room_center - Vector2(0, RoomHeight/2)
	d4.position = room_center + Vector2(0, RoomHeight/2)
	
	doors.append(d)
	doors.append(d2)
	doors.append(d3)
	doors.append(d4)
	
	#start the timer!
	wave_timer.start(5)
	
func _on_wave_finished_sound_timer_timeout() -> void:
	sound_wave_finished_bell.play()
	
func _on_wave_end_timer_timeout() -> void:
	print('TIME')
	do_wave_end(end_room_center)
	
func do_wave_end(room_center: Vector2):
	sound_door_open.play()
	reset_collision = false
	room_finished = true
	print("yay you killed 'em all")
	# Iterate over a copy of the doors array to avoid modifying it while looping
	for door in doors.duplicate():
		doors.erase(door)
		door.queue_free()
	
func wave_end(room_center: Vector2):
	if wave_end_timer.is_stopped():
		end_room_center = room_center
		print('starting wave end timer')
		wave_finished_sound_timer.start(0.6)
		wave_end_timer.start(1.8)
	
func wave_actions(room_center: Vector2):
	if enemy_spawn_timer.is_stopped():
		enemy_spawn_timer.start(1)
		var newEnemy = SmallGhost.instantiate()
		add_child(newEnemy)

		# RoomWidth, RoomHeight
		var newPosition = random_spawn_position(room_center)
		newEnemy.position = newPosition

		# Connect the enemy's "death" signal to the removal function
		newEnemy.connect("death", Callable(self, "_on_enemy_death").bind(newEnemy))

		# Add the new enemy to the global enemies array
		enemies.append(newEnemy)

func updateArea2DCollisionShape(room_center: Vector2):
	print('updating collision shape')
	reset_collision = true
	
	var room_width = RoomWidth - 64
	var room_height = RoomHeight - 64

	# Update the ColorRect position to visualize the spawn area
	color_rect.position = room_center - Vector2(room_width / 2, room_height / 2)
	color_rect.size = Vector2(room_width, room_height)

	# Create a new rectangle shape for the collision shape
	var new_shape = RectangleShape2D.new()
	new_shape.extents = Vector2(room_width / 2, room_height / 2)  # Set extents to half the width and height



	# Update the collision shape with the new shape
	collision_shape_2d.shape = new_shape

	# Position the CollisionShape2D to match the spawn area
	collision_shape_2d.position = room_center  # Center it at the room center
	
	area_2d.monitoring = true

func random_spawn_position(room_center: Vector2) -> Vector2:
	# Adjusted room dimensions for the spawn area
	var room_width = RoomWidth - 64
	var room_height = RoomHeight - 64

	# Position the ColorRect to visualize the spawn area
	color_rect.position = room_center - Vector2(room_width / 2, room_height / 2)
	color_rect.size = Vector2(room_width, room_height)

	var newPosition: Vector2
	var valid_position_found = false

	var finalPos = Vector2(0,0)

	while not valid_position_found:
		# Generate a random position on the edge of the rectangle
		var side = randi() % 4  # Randomly pick a side: 0=top, 1=bottom, 2=left, 3=right

		match side:
			0:  # Top edge
				newPosition = Vector2(randf() * room_width, -room_height / 2) - Vector2(room_width / 2, 0)
			1:  # Bottom edge
				newPosition = Vector2(randf() * room_width, room_height / 2) - Vector2(room_width / 2, 0)
			2:  # Left edge
				newPosition = Vector2(-room_width / 2, randf() * room_height) - Vector2(0, room_height / 2)
			3:  # Right edge
				newPosition = Vector2(room_width / 2, randf() * room_height) - Vector2(0, room_height / 2)

		finalPos = room_center + newPosition

		# Check if the new position is at least 64 pixels away from the player
		if is_instance_valid(player) and finalPos.distance_to(player.global_position) >= 72:
			valid_position_found = true

	# Adjust the position relative to the room center and return the final position
	return finalPos

# Function to handle enemy removal
func _on_enemy_death(enemy: Node):
	# Remove the enemy from the enemies array
	enemies.erase(enemy)
	# Queue the enemy for deletion

	enemy.queue_free()

func _process(delta):
	var room_center = get_room_center(player.global_position)
	
	if room_center != in_room && !reset_collision:
		updateArea2DCollisionShape(room_center)
		
	if targets.size() > 0: 
		entered_room(room_center)

	if !wave_timer.is_stopped():
		wave_actions(room_center)
	else:
		if enemies.size() == 0 and !room_finished:
			wave_end(room_center)

	
	room_info_label.text = str(room_center.x) + ", " + str(room_center.y) + "\n enemies in wave: " + str(enemies.size())
	debug_label.text = player.getDebugLabel()

func _physics_process(delta: float) -> void:
	target_camera_position = Vector2(0, 0)

	var room_center = Vector2(0,0)
	if is_instance_valid(player):
		# Calculate the room center based on the player's position
		room_center = get_room_center(player.global_position)

		# Bias the camera towards the player's position
		var player_bias_factor = 0.1  # Adjust for more/less bias toward player

		# Get the global mouse position in world space
		var mouse_position = get_global_mouse_position()
		var mouse_bias_factor = 0.1  # Adjust for more/less bias toward mouse

		# Interpolate toward the player's position
		var target_position = lerp(room_center, player.global_position, player_bias_factor)

		# Further bias towards the mouse's position
		target_camera_position = lerp(target_position, mouse_position, mouse_bias_factor)
	else:
		# Respawn the player if the respawn timer is stopped
		if player_respawn_timer.is_stopped():
			var p = playerObject.instantiate()
			add_child(p)
			player = p
			health = 6
			p.position = Vector2(0, 56)

	vignette.global_position = room_center
	# Smoothly move the camera towards the biased target position
	camera.global_position = camera.global_position.lerp(target_camera_position, delta * follow_smoothing)


func _on_area_2d_body_entered(body: Node2D) -> void:
	targets.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
