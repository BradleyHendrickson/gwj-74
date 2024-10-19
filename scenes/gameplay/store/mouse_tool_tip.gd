extends Label

var margin = 10  # Margin to keep some space from the screen edges

func _ready():
	# Hide the tooltip initially
	visible = false

func show_tooltip(text, position):
	# Set the tooltip text and place it on screen
	self.text = text
	global_position = position  # Set the initial position
	adjust_position()  # Ensure it's on screen
	visible = true

func adjust_position():
	# Get the viewport size (screen size)
	var viewport_size = get_viewport_rect().size

	# Get the size of the tooltip (Label's size)
	var tooltip_size = get_minimum_size()  # Use the minimum size of the Control node

	# Adjust X position if the tooltip goes off the right edge
	if global_position.x + tooltip_size.x > viewport_size.x - margin:
		global_position.x = viewport_size.x - tooltip_size.x - margin

	# Adjust X position if the tooltip goes off the left edge
	if global_position.x < margin:
		global_position.x = margin

	# Adjust Y position if the tooltip goes off the bottom edge
	if global_position.y + tooltip_size.y > viewport_size.y - margin:
		global_position.y = viewport_size.y - tooltip_size.y - margin

	# Adjust Y position if the tooltip goes off the top edge
	if global_position.y < margin:
		global_position.y = margin

func _process(delta):
	# Optional: Adjust position dynamically if needed
	if visible:
		adjust_position()
