extends StaticBody2D

@onready var collision_shape = $FloorBoundary
@onready var floor_sprite_template = $FloorSprite

@export var floor_sprite_count: int = 20

func _ready():
	add_floor_sprites()

func add_floor_sprites():
	# Ensure the floor sprite template is assigned
	if not floor_sprite_template:
		print("Floor sprite template not found!")
		return
	
	# get texture size
	# TODO: we could probably scale the sprite automatically based on
	# how much space is between lower screen boundary and FloorBoundary
	var sprite_size = floor_sprite_template.texture.get_size() * floor_sprite_template.scale
	
	# Check if the shape is a WorldBoundaryShape2D
	var shape = collision_shape.shape
	if shape is WorldBoundaryShape2D:
		# Calculate the position and add floor sprites
		var current_x = 0
		for i in range(floor_sprite_count):
			var floor_sprite = floor_sprite_template.duplicate() as Sprite2D
			add_child(floor_sprite)
			
			# Set the position of the floor sprite
			floor_sprite.global_position = Vector2(current_x, collision_shape.global_position.y + sprite_size.y / 2.0)
			floor_sprite.show()
			
			# Move to the next position
			current_x += sprite_size.x

	else:
		print("Unsupported shape type. Only WorldBoundaryShape2D is supported for now.")
