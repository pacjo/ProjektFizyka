extends RigidBody2D

@export var health = 200

const DAMAGE_MULTIPLIER = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	# without those collisions won't be detected
	contact_monitor = true
	max_contacts_reported = 8

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Ball":
		var relative_velocity = body.linear_velocity - self.linear_velocity
		var impact_force = relative_velocity.normalized().length()
		
		var damage = impact_force * DAMAGE_MULTIPLIER
		health -= damage
		if health <= 0:
			#preserve_ball_velocity(body)
			
			queue_free()
			
		print("Hit by: ", body.name, " with force: ", impact_force, " Health remaining: ", health)

func preserve_ball_velocity(ball):
	var ball_velocity = ball.linear_velocity
	print("starting await, vel: ", ball_velocity)
	await get_tree().process_frame
	print("restoring velocity: ", ball_velocity)
	ball.linear_velocity = ball_velocity
