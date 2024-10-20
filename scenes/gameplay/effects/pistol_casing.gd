extends RigidBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FRICTION = 0



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if linear_velocity.length() == 0:
		moveRand()

func moveUp():
	var mag = randf_range(50,180)
	var dir= deg_to_rad(randf_range(0,180)-180)
	linear_velocity = Vector2(cos(dir), sin(dir))* mag * SPEED
	
	
	
func moveDir(direction):
	var mag = randf_range(50,180)
	var dir= deg_to_rad(rad_to_deg(direction))
	linear_velocity = Vector2(cos(dir), sin(dir)) * mag
	
func moveRand():
	var mag = randf_range(50,180)
	var dir= deg_to_rad(randf_range(0,180))
	linear_velocity = Vector2(cos(dir), sin(dir)) * mag



func _physics_process(delta):
	
		
	# Apply friction
	linear_velocity.x = move_toward(linear_velocity.x, 0, FRICTION * delta)
	linear_velocity.y = move_toward(linear_velocity.y, 0, FRICTION * delta)
	
