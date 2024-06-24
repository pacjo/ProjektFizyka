extends StaticBody2D

@onready var collision_shape = $FloorBoundary
@onready var floor_sprite_template = $FloorSprite

@export var floor_sprite_count: int = 20

func _ready():
	if GameManager.moon_mode:
		$FloorSprite.texture = preload("res://assets/smooth_basalt.webp")
	else:
		$FloorSprite.texture = preload("res://assets/grass.webp")
	
	add_floor_sprites()

func add_floor_sprites():
	# Ensure the floor sprite template is assigned
	if not floor_sprite_template:
		print("Floor sprite template not found!")
		return
	
	# Get the texture size
	var texture_size = floor_sprite_template.texture.get_size()
	
	# Get the height difference between the bottom of the screen and the FloorBoundary
	var screen_bottom = get_viewport_rect().size.y
	var floor_boundary_y = collision_shape.global_position.y
	var height_difference = screen_bottom - floor_boundary_y

	# Calculate the required scale to fit the height difference
	var scale_factor = height_difference / texture_size.y
	floor_sprite_template.scale = Vector2(scale_factor, scale_factor)
	
	# Get the scaled sprite size
	var sprite_size = texture_size * scale_factor
	
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
