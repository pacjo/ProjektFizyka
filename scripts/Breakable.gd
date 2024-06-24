extends RigidBody2D

class_name Breakable

const DAMAGE_MULTIPLIER = 0.6

@export var post_collision_speed_multiplier = 0.5
var health = 100  		# Default value
var score_points = 50	# Default value

func _ready():
	# without those collisions won't be detected
	contact_monitor = true
	max_contacts_reported = 8
	
	# Change gravity scale in moon mode
	if GameManager.moon_mode:
		gravity_scale = 0.1
	else:
		gravity_scale = 0.9

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Ball":  # TODO: don't use name
		var relative_velocity = body.linear_velocity - self.linear_velocity
		var impact_force = relative_velocity.length()
		
		var damage = impact_force * DAMAGE_MULTIPLIER
		health -= damage
		
		if health <= 0:
			call_deferred("set_contact_monitor", false)
			
			play_destruction_animation()
			ScoreManager.add_score(score_points)
			preserve_ball_velocity(body)

func preserve_ball_velocity(ball):
	ball.linear_velocity = ball.current_velocity * post_collision_speed_multiplier

func play_destruction_animation():
	#print(name, " - will play animation, status: ", $AnimationPlayer.is_playing())
	$AnimationPlayer.play("destruction")
	#print(name, " - animation played, status: ", $AnimationPlayer.is_playing(), ", ", $AnimationPlayer.current_animation)

func _on_animation_finished(anim_name):
	if anim_name == "destruction":
		queue_free()
