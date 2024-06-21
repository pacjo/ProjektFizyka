extends Control

func _ready():
	$MainMenuContainer/StartButton.text = "Start Game"
	$MainMenuContainer/AboutButton.text = "About"
	$MainMenuContainer/QuitButton.text = "Exit"
	
	$SettingsMenuContainer/MusicButton.texture_normal = preload("res://assets/volume-off.svg")
	$SettingsMenuContainer/MoonButton.texture_normal = preload("res://assets/space-station.svg")

	# Connect buttons to their respective functions
	$MainMenuContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$MainMenuContainer/AboutButton.pressed.connect(_on_about_button_pressed)
	$MainMenuContainer/QuitButton.pressed.connect(_on_exit_button_pressed)
	
	$SettingsMenuContainer/MusicButton.pressed.connect(_on_music_button_pressed)
	$SettingsMenuContainer/MoonButton.pressed.connect(_on_moon_button_pressed)

func _process(_delta):
	if Input.is_action_pressed("pause"):
		get_tree().quit()		# TODO: change to pause

func _on_start_button_pressed():
	# Start the game (replace 'GameScene' with the actual path to your game scene)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_about_button_pressed():
	# TODO: probably a popup?
	print("About button pressed")

func _on_exit_button_pressed():
	# exit game
	get_tree().quit()

func _on_music_button_pressed():
	# Toggle music on/off
	print("Music toggle button pressed")

func _on_moon_button_pressed():
	# enable "moon mode"
	print("MOON MODE!!")
