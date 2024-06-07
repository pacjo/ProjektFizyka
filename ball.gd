extends RigidBody2D

var arrow: Line2D
var is_dragging: bool = false
const MIN_DRAG_DISTANCE = 30
const MAX_ARROW_LENGTH = 150
const VELOCITY_MULTIPLIER = 1000  # Adjust this value as needed

func _ready():
	arrow = $Line2D  # Adjust the path to your Line2D node if different
	arrow.visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if _is_mouse_over_ball(event.global_position):
					is_dragging = true
					arrow.visible = false  # Start with arrow hidden until we check distance
					handle_event(event.global_position)  # Update arrow initially to ensure correct visibility
			else:
				is_dragging = false
				if arrow.visible:
					apply_velocity(event.global_position)
				arrow.visible = false
	elif event is InputEventMouseMotion and is_dragging:
		handle_event(event.global_position)

func _is_mouse_over_ball(mouse_position):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_position
	var result = space_state.intersect_point(query)
	for item in result:
		if item.collider == self:
			return true
	return false

func handle_event(mouse_position):
	var distance = global_position.distance_to(mouse_position)
	# Draw arrow
	if distance < MIN_DRAG_DISTANCE:
		arrow.visible = false
		return
	
	# TODO: fix arrow movement when ball is rotating
	var direction = (global_position - mouse_position).normalized()
	distance = min(distance, MAX_ARROW_LENGTH)
	arrow.points = [Vector2.ZERO, direction * distance]
	arrow.visible = true

func apply_velocity(mouse_position):
	var direction = (global_position - mouse_position).normalized()
	linear_velocity = direction * VELOCITY_MULTIPLIER
