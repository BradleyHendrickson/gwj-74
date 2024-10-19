extends Node2D

@onready var sound_open: AudioStreamPlayer2D = $SoundOpen
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var open = false
var targets : Array = []
@onready var sound_go_down_stairs: AudioStreamPlayer2D = $SoundGoDownStairs
@onready var sound_close_trap_door: AudioStreamPlayer2D = $SoundCloseTrapDoor

signal door_triggered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open = false
	self.door_triggered.connect(Callable(self, "_on_door_triggered").bind(self))

# Toggle the trapdoor when the signal is emitted
func _on_door_triggered(self_ref: Node2D) -> void:
	if self_ref.isOpen():
		self_ref.closeDoor()
	else:
		self_ref.openDoor()

func isOpen():
	return open

func openDoor():
	open = true
	animated_sprite_2d.play("open")
	
func closeDoor():
	open = false
	animated_sprite_2d.play("default")
	#animated_sprite_2d.play("open")

func playSound():
	sound_open.play()

func _on_sound_close_trap_door_finished() -> void:
	sound_go_down_stairs.play()

		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isOpen() and targets.size() > 0:
		var p = targets[0]
		if p.has_method("pause"):
			p.pause()
		closeDoor()
		sound_close_trap_door.play()
		
		var gamecontrollers = get_tree().get_nodes_in_group("gamecontroller")
		if gamecontrollers.is_empty():
			return
		
		gamecontrollers[0].shopTransitionIn()


func _on_area_2d_body_entered(body: Node2D) -> void:
	targets.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
