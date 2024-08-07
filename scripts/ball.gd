extends RigidBody2D

var arrow: Line2D
var is_dragging: bool = false
var wasShoot: bool = false
@export var health: float = 10

var current_velocity = Vector2.ZERO

const MIN_DRAG_DISTANCE = 30
const MAX_ARROW_LENGTH = 150
const VELOCITY_MULTIPLIER = 2000

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
		queue_free()

func _physics_process(_delta):
	# Update current velocity every frame
	current_velocity = linear_velocity

func _input(event):
	if !wasShoot:
		if event is InputEventScreenTouch:
			if event.pressed:
				# We started touching the ball - show arrow and calculate stuff
				if _is_pointer_over_ball(event.position):
					is_dragging = true
					draw_arrow(event.position)
			else:
				# We stopped touching the ball - throw it
				is_dragging = false
				if arrow.visible:
					kick_ball(event.position)
				arrow.visible = false
		elif event is InputEventScreenDrag and is_dragging:
			# Continue dragging the ball - update arrow
			draw_arrow(event.position)

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

func kick_ball(pointer_position):
	var distance = global_position.distance_to(pointer_position)
	var direction = (global_position - pointer_position).normalized()
	var strength = (min(distance, MAX_ARROW_LENGTH) / MAX_ARROW_LENGTH)
	
	# start whole kick shenanigans
	var player: Area2D = get_parent().get_node("Player")
	player.kick_ball(strength, self, direction * strength * VELOCITY_MULTIPLIER)
	
	## add velocity
	#linear_velocity = direction * strength * VELOCITY_MULTIPLIER
	#wasShoot = true
