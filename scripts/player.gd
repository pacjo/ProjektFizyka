extends Area2D

@onready var legless_sprite: Sprite2D = $LeglessSprite
@onready var leg_sprite: Sprite2D = $LegSprite

const DEFAULT_ROTATION = 55
const MAX_ROTATION = 120
const POST_KICK_ROTATION = 0

func _ready():
	leg_sprite.rotation_degrees = DEFAULT_ROTATION

func kick_ball(strength: float, ball: RigidBody2D, velocity: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(
		$LegSprite,
		"rotation_degrees",
		MAX_ROTATION - MAX_ROTATION * (1-strength),
		0.5
	).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		$LegSprite,
		"rotation_degrees",
		DEFAULT_ROTATION,
		0.2
	).set_trans(Tween.TRANS_CUBIC)
	# kick
	tween.tween_callback(_actually_kick_ball.bind(ball, velocity))
	# finish the animation
	tween.tween_property(
		$LegSprite,
		"rotation_degrees",
		0,
		0.05
	).set_trans(Tween.TRANS_CUBIC)

func _actually_kick_ball(ball: RigidBody2D, velocity: Vector2):
	ball.linear_velocity = velocity
	ball.wasShoot = true
