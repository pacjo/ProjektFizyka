extends RigidBody2D

const DAMAGE_MULTIPLIER = 0.6

@export var health = 200
@export var post_colision_speed_multiplier = 0.5
@export var score_points = 100

func _ready():
	# without those collisions won't be detected
	contact_monitor = true
	max_contacts_reported = 8

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Ball":		# TODO: don't use name
		# Use the current_velocity property of the ball
		var relative_velocity = body.linear_velocity - self.linear_velocity
		var impact_force = relative_velocity.length()
		
		var damage = impact_force * DAMAGE_MULTIPLIER
		health -= damage
		#print(name + " - hit - impact force: ", impact_force, ", health: ", health)
		if health <= 0:
			play_destruction_animation()
			ScoreManager.add_score(score_points)
			preserve_ball_velocity(body)

func preserve_ball_velocity(ball):
	ball.linear_velocity = ball.current_velocity * post_colision_speed_multiplier
	queue_free()

func play_destruction_animation():
	print("animation played")
	$AnimationPlayer.play("destruction")
