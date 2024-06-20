extends RigidBody2D

var arrow: Line2D
var is_dragging: bool = false
var wasShoot: bool = false
@export var health: float = 10

const MIN_DRAG_DISTANCE = 30
const MAX_ARROW_LENGTH = 150
const VELOCITY_MULTIPLIER = 1100

func _ready():
	arrow = $Line2D
	arrow.visible = false

func _process(delta):
	# delta is in seconds and by substracting it from health (by default
	# being a value of 10) ball object will live 10 seconds
	# ...and we only do that if it was already shoot (wasShoot)
	if wasShoot:
		health -= delta

	if health <= 0:
		# TODO: add animation (maybe a disappearing cloud?)
		free()

func _input(event):
	if !wasShoot:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# we started dragging the ball - show arrow and calculate stuff
				if _is_pointer_over_ball(event.global_position):
					is_dragging = true
					draw_arrow(event.global_position)
			else:
				# we stopped dragging the ball - throw it
				is_dragging = false
				if arrow.visible:
					apply_velocity(event.global_position)
				arrow.visible = false
		elif event is InputEventMouseMotion and is_dragging:
			draw_arrow(event.global_position)

func _is_pointer_over_ball(pointer_position):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	
	query.position = pointer_position
	var result = space_state.intersect_point(query)
	
	for item in result:
		if item.collider == self:
			return true
	return false

func draw_arrow(pointer_position):
	var distance = global_position.distance_to(pointer_position)
	if distance < MIN_DRAG_DISTANCE:
		arrow.visible = false
		return
	
	var direction = (global_position - pointer_position).normalized()
	distance = min(distance, MAX_ARROW_LENGTH)
	arrow.points = [Vector2.ZERO, direction * distance]
	arrow.visible = true
	
	# also rotate player's leg (TODO: move this somewhere else?)
	var player: Area2D = get_parent().get_node("Player")
	player.rotate_leg_sprite((distance / MAX_ARROW_LENGTH) * 2 * 360)		# TODO: make const

func apply_velocity(pointer_position):
	var distance = global_position.distance_to(pointer_position)
	var direction = (global_position - pointer_position).normalized()
	linear_velocity = direction * (distance / MAX_ARROW_LENGTH) * VELOCITY_MULTIPLIER		# TODO: limit by some max
	
	wasShoot = true
