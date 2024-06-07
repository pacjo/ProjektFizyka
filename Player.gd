extends Area2D

# set manually in the Inspector sidebar
@onready var legless_sprite: Sprite2D = $LeglessSprite
@onready var leg_sprite: Sprite2D = $LegSprite

func _ready():
	rotate_leg_sprite(55)

func rotate_leg_sprite(angle_degrees: float):
	leg_sprite.rotation_degrees = angle_degrees
